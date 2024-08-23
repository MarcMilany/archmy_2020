#!/usr/bin/env bash
# Install script debtap
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

DOWNLOADS="russian"  # Installer default language (Язык установки по умолчанию)

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
clear
echo ""
echo -e "${BLUE}:: ${NC}Создадим папку (downloads), и перейдём в созданную папку "
#echo " Создадим папку (downloads), и переходим в созданную папку "
# Create a folder (downloads), and go to the created folder
echo -e "${MAGENTA}=> ${NC}Почти весь процесс: по загрузке, сборке софта (пакетов) устанавливаемых из AUR - будет проходить в папке (downloads)."
echo -e "${CYAN}:: ${NC}Если Вы захотите сохранить софт (пакеты) устанавливаемых из AUR, и в последствии создать свой маленький (пользовательский репозиторий Arch), тогда перед удалением папки (downloads) в заключении работы скрипта, скопируйте нужные вам пакеты из папки (downloads) в другую директорию."
echo -e "${YELLOW}==> Примечание: ${NC}Вы можете пропустить создание папки (downloads), тогда сборка софта (пакетов) устанавливаемых из AUR - будет проходить в папке указанной (для сборки) Pacman gui (в его настройках, если таковой был установлен), или по умолчанию в одной из системных папок (tmp;...;...)."
echo " В заключении работы сценария (скрипта) созданная папка (downloads) - Будет полностью удалена из домашней (home) директории! "
echo " Будьте внимательны! Вы можете пропустить это действие. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да создать папку (downloads),     0 - НЕТ - Пропустить действие: " i_folder  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_folder" =~ [^10] ]]
do
    :
done
if [[ $i_folder == 0 ]]; then
  echo ""
  echo " Создание папки (downloads) пропущено "
elif [[ $i_folder == 1 ]]; then
  echo ""
  echo " Создаём и переходим в созданную папку (downloads) "
  mkdir ~/downloads  # создание папки (downloads)
  cd ~/downloads  # перейдём в созданную папку
  echo " Посмотрим в какой директории мы находимся "
  pwd  # покажет в какой директории мы находимся
fi

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

