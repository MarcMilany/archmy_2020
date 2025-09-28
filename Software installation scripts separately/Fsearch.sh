#!/usr/bin/env bash
# Install script Fsearch
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

Fsearch_LANG="russian"  # Installer default language (Язык установки по умолчанию)

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
echo -e "${BLUE}:: ${NC}Установить Fsearch (fsearch-git) — Поиск файлов?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Для отчетов об ошибках и запросов на новые функции используйте систему отслеживания ошибок: (https://github.com/cboxdoerfer/fsearch/issues). По всем остальным вопросам, связанным с FSearch, вы можете обратиться ко мне на Matrix: (https://matrix.to/#/#fsearch:matrix.org). ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Fsearch — это быстрая утилита поиска файлов, вдохновленная (созданная по мотивам) Everything Search Engine. Она написана на языке C и основана на GTK3. Локализация FSearch осуществляется с помощью Weblate. Поисковик файлов — fsearch, это вещь которая позволяет индексировать ваши файловые системы с мгновенной скоростью для поиска среди всех файлов за секунды, вы можете сохранять базы данных и обновлять только когда это понадобится, лично мне не хватает ее интеграции с поиском в Xfce чтобы можно было использовать в более подручном способе. Этот проект Лицензируется под GPL-2.0 или более поздняя версия. ${NC}"
echo " Домашняя страница: https://github.com/cboxdoerfer/fsearch ; (https://aur.archlinux.org/packages/fsearch-git). "
echo -e "${BLUE}:: ${NC}Функции: Мгновенные (по мере ввода) результаты; Расширенный синтаксис поиска; Поддержка подстановочных знаков; Поддержка регулярных выражений; Поддержка фильтров (поиск только файлов, папок или всего); Включать и исключать определенные папки для индексации; Возможность исключения определенных файлов/папок из индекса с помощью подстановочных выражений. Быстрая сортировка по имени файла, пути, размеру или времени изменения. Настраиваемый интерфейс (например, переключение между традиционным пользовательским интерфейсом с панелью меню и клиентскими украшениями). "
echo -e "${CYAN}:: ${NC}*Текущие ограничения: Сортировка большого количества результатов по Type может быть очень медленной, поскольку сбор этой информации является дорогостоящим, а данные не индексируются. Это также означает, что когда представление сортируется по Type , поиск сбросит порядок сортировки на Name. Сортировку нельзя прервать. Обычно это не проблема, поскольку она очень быстрая для всех столбцов, кроме столбца Тип . Использование опции «Переместить в корзину» не обновляет индекс базы данных, поэтому удаленные файлы/папки отображаются в списке результатов, как будто с ними ничего не произошло. "
echo -e "${CYAN}:: ${NC}Установка Fsearch (fsearch-git) проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/fsearch-git.git), (https://aur.archlinux.org/packages/fsearch-git) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_fsearch  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_fsearch" =~ [^10] ]]
do
    :
done
if [[ $in_fsearch == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_fsearch == 1 ]]; then
  echo ""
  echo " Установка  "
  echo ""
  echo " Установка утилиты (пакета) Fsearch (fsearch-git) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
############# fsearch-git #############
yay -S fsearch-git --noconfirm  # Быстрая графическая утилита поиска файлов. Версия в разработке ; https://aur.archlinux.org/fsearch-git.git (только для чтения, нажмите, чтобы скопировать) ; https://cboxdoerfer.github.io/fsearch ; https://aur.archlinux.org/packages/fsearch-git ; Конфликты: с fsearch ; Обеспечивает: fsearch ; 2024-08-26 02:37 (UTC)
#git clone https://aur.archlinux.org/fsearch-git.git   # (только для чтения, нажмите, чтобы скопировать)
#cd fsearch-git
# makepkg -fsri
#makepkg -si --noconfirm  #-не спрашивать каких-либо подтверждений
# makepkg -si
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
#rm -Rf fsearch-git  # удаляем директорию сборки
# rm -rf fsearch-git
######################
  echo ""
  echo " Посмотрите информацию о версии (fsearch) "
sudo pacman -Q fsearch  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
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

