#!/usr/bin/env bash
# Install script GtkHash
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

GtkHash_LANG="russian"  # Installer default language (Язык установки по умолчанию)

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
  <<< Установка утилит (пакетов) для вычисления контрольных сумм файлов или .iso в Archlinux ه = ⁿ⁼⁰ ¹ₙ >>> ${NC}"
# Installing utilities (packages) for calculating checksums of files or .iso in Archlinux
sleep 03

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить GtkHash (gtkhash) — Утилита для вычисления дайджестов сообщений или контрольных сумм?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *md5sum — это мощная утилита для создания и проверки контрольных сумм MD5 (Message Digest Algorithm 5). md5sum генерирует 128-битный (16-байтовый) хеш, который отображается как 32-символьное шестнадцатеричное число. Основная цель использования md5sum — убедиться, что файл не был изменен или поврежден во время передачи или хранения. Сравнивая контрольные суммы исходного и полученного файлов, вы можете гарантировать их идентичность. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}GtkHash — маленькая C (си) / GTK (Gnome) графическая утилита GTK+ для расчёта контрольных сумм файлов (хеш сумм) по нескольким алгоритмам (Calculator hash) для файлов в Linux. GtkHash - это настольная утилита для вычисления дайджестов сообщений или контрольных сумм.  Разрабатывался GtkHash как более простая и удобная в использовании альтернатива консольным утилитам аналогичного назначения (md5sum, sha1sum и др). Поддерживаются большинство наиболее часто используемых алгоритмов хеширования и вычисления контрольной суммы, включая MD5, SHA1, SHA2 (SHA256/SHA512), SHA3 и BLAKE2, в трёх форматах (видах). GtkHash поддерживает индивидуальную и групповую обработку файлов (в параллельном, многопоточном режиме), хеширование с ключом (HMAC), есть возможность вычисления контрольных сумм на удалённых файловых системах (GIO/GVfs). GtkHash с помощью расширений (скриптов) интегрируется в файловые менеджеры Caja (MATE), Nautilus (GNOME), Nemo (Cinnamon), Peony (UKUI) и Thunar (Xfce), результаты вычислений можно сохранить в текстовом файле. GtkHash является свободным программным обеспечением: вы можете распространять его и/или изменять в соответствии с условиями GNU General Public License (GPL), опубликованной Free Software Foundation, либо версии 2 Лицензии, либо (по вашему выбору) любой более поздней версии. ${NC}"
echo " Домашняя страница: https://github.com/tristanheaven/gtkhash ; (https://aur.archlinux.org/packages/gtkhash ; https://aur.archlinux.org/packages/gtkhash-thunar). "
echo -e "${BLUE}:: ${NC}Функции: Поддержка проверки контрольных сумм файлов с помощью sfv, sha256sum и т. д.. Ключевое хеширование (HMAC); Параллельный/многопоточный расчет хэша; Удаленный доступ к файлам с использованием GIO/GVfs; Интеграция файлового менеджера; Маленький и быстрый. *Особенности: поддерживает различные алгоритмы контрольных сумм, включая MD5, SHA-1, SHA-256, SHA-512 и другие; интегрируется с файловым менеджером, позволяет рассчитывать контрольные суммы непосредственно из контекстного меню; позволяет сравнивать вычисленный хеш с известным значением. "
echo -e "${CYAN}:: ${NC}*Хеширование (hashing) — преобразование входного массива данных произвольной длинны, в выходную битовую строку фиксированной длинны. Такие преобразования так же называют хеш-функциями свёртки, а их результаты называют хешем, хеш-кодом или дайджестом сообщения (message digest). Хеширование предназначается для создания "отпечатков" или "дайджестов" файлов для последующей проверки их подлинности (целостности). Существует множество алгоритмов хеширования, отличающихся различными свойствами и применяются для обнаружения ошибок которые могут возникнуть при передаче и/или хранении информации. "
echo -e "${CYAN}:: ${NC}Установка GtkHash (gtkhash) и (gtkhash-thunar), проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/gtkhash.git), (https://aur.archlinux.org/gtkhash-thunar.git) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Установить GtkHash (gtkhash),    2 - Установить GtkHash-Thunar (gtkhash-thunar),

    0 - НЕТ - Пропустить установку: " in_gtkhash  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_gtkhash" =~ [^120] ]]
do
    :
done
if [[ $in_gtkhash == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_gtkhash == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) GtkHash (gtkhash) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed libgcrypt  # Универсальная криптографическая библиотека на основе кода GnuPG ; https://archlinux.org/packages/core/x86_64/libgcrypt/ ; https://www.gnupg.org/ ; 2025-08-17 10:27 UTC
sudo pacman -S --noconfirm --needed lib32-libgcrypt  # Универсальная криптографическая библиотека на основе кода GnuPG (32-бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-libgcrypt/ ; https://www.gnupg.org/ ; 2025-08-26 18:17 UTC
####### gtkhash ##########
yay -S gtkhash --noconfirm  # Утилита GTK+ для вычисления дайджестов сообщений или контрольных сумм ; https://aur.archlinux.org/packages/gtkhash ; https://aur.archlinux.org/gtkhash.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/tristanheaven/gtkhash ; https://github.com/tristanheaven/gtkhash/releases/download/v1.5/gtkhash-1.5.tar.xz ; Конфликты: с gtkhash-caja, gtkhash-nautilus, gtkhash-nemo, gtkhash-thunar ; Обеспечивает: gtkhash ; 2023-06-06 00:32 (UTC)
####### gtkhash ##########
#git clone https://aur.archlinux.org/gtkhash.git   # (только для чтения, нажмите, чтобы скопировать)
#cd gtkhash
#makepkg -fsri
#makepkg -si --noconfirm  #-не спрашивать каких-либо подтверждений
# makepkg -si
#makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
#rm -Rf gtkhash  # удаляем директорию сборки
# rm -rf gtkhash
###################
  echo ""
  echo " Посмотрите информацию о версии (gtkhash) "
sudo pacman -Q gtkhash  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_gtkhash == 2 ]]; then
  echo ""
  echo " Установка утилиты (пакета) GtkHash-Thunar (gtkhash-thunar) "
  echo " Конфликты: с gtkhash, gtkhash-caja, gtkhash-nautilus, gtkhash-nemo "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed libgcrypt  # Универсальная криптографическая библиотека на основе кода GnuPG ; https://archlinux.org/packages/core/x86_64/libgcrypt/ ; https://www.gnupg.org/ ; 2025-08-17 10:27 UTC
sudo pacman -S --noconfirm --needed lib32-libgcrypt  # Универсальная криптографическая библиотека на основе кода GnuPG (32-бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-libgcrypt/ ; https://www.gnupg.org/ ; 2025-08-26 18:17 UTC
####### gtkhash-thunar ##########
yay -S gtkhash-thunar --noconfirm  # Утилита GTK+ для вычисления дайджестов сообщений или контрольных сумм (Gtkhash с плагином файлового менеджера Thunar) ; https://aur.archlinux.org/packages/gtkhash-thunar ; https://aur.archlinux.org/gtkhash-thunar.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/tristanheaven/gtkhash ; https://github.com/tristanheaven/gtkhash/releases/download/v1.5/gtkhash-1.5.tar.xz ; Конфликты: с gtkhash, gtkhash-caja, gtkhash-nautilus, gtkhash-nemo ; Обеспечивает: gtkhash, gtkhash-thunar ; 2023-06-06 00:23 (UTC)
####### gtkhash-thunar ##########
#git clone https://aur.archlinux.org/gtkhash-thunar.git   # (только для чтения, нажмите, чтобы скопировать) https://aur.archlinux.org/packages/gtkhash
#cd gtkhash-thunar
#makepkg -fsri
#makepkg -si --noconfirm  #-не спрашивать каких-либо подтверждений
# makepkg -si
#makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
#rm -Rf gtkhash-thunar  # удаляем директорию сборки
# rm -rf gtkhash-thunar
#########################
  echo ""
  echo " Посмотрите информацию о версии (gtkhash) "
sudo pacman -Q gtkhash-thunar  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##############
### Установка утилиты (пакета): gtkhash-caja , gtkhash-nemo
####### gtkhash-caja ##########
# yay -S gtkhash-caja --noconfirm  # Утилита GTK+ для вычисления дайджестов сообщений или контрольных сумм (Gtkhash с плагином Caja Filemanager) ; https://aur.archlinux.org/packages/gtkhash-caja ; https://aur.archlinux.org/gtkhash-caja.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/tristanheaven/gtkhash ; https://github.com/tristanheaven/gtkhash/releases/download/v1.5/gtkhash-1.5.tar.xz ; Конфликты: с gtkhash, gtkhash-nautilus, gtkhash-nemo, gtkhash-thunar ; Обеспечивает: gtkhash, gtkhash-caja ; 2023-06-06 00:28 (UTC)
####### gtkhash-nemo ##########
# yay -S gtkhash-nemo --noconfirm  # Утилита GTK+ для вычисления дайджестов сообщений или контрольных сумм (Gtkhash с плагином файлового менеджера Thunar) ; https://aur.archlinux.org/packages/gtkhash-nemo ; https://aur.archlinux.org/gtkhash-nemo.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/tristanheaven/gtkhash ; https://github.com/tristanheaven/gtkhash/releases/download/v1.5/gtkhash-1.5.tar.xz ; Конфликты: с gtkhash, gtkhash-caja, gtkhash-nautilus, gtkhash-thunar ; Обеспечивает: gtkhash, gtkhash-nemo ; 2023-06-06 00:26 (UTC)
#####################################
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

