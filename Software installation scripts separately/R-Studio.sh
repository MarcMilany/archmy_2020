#!/usr/bin/env bash
# Install script R-Studio
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

R-Studio_LANG="russian"  # Installer default language (Язык установки по умолчанию)

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
  <<< Установка утилит (пакетов) для восстановления удалённых и повреждённых файлов в Archlinux 📄 📂 🗂️ 📁 >>> ${NC}"
# Installing utilities (packages) to recover deleted and corrupted files in Archlinux
echo ""
echo -e "${YELLOW}==> Примечание! ${BOLD} *Для восстановления удалённых и повреждённых файлов в Linux доступны как встроенные средства, так и специализированные утилиты. Важно учитывать, что файловые системы ведут себя по-разному: ext2/ext3/ext4 — относительно дружелюбны к восстановлению, XFS — сложнее, но есть специализированные инструменты, Btrfs — имеет встроенные механизмы восстановления. *Рекомендации: Немедленно прекратить запись на диск — отмонтировать раздел, перевести систему в read-only режим, чтобы минимизировать активность на диске. Создать резервную копию повреждённого тома (ФС, раздела или всего диска) — это поможет работать с копией, а не с оригиналом. Чем меньше времени прошло с момента удаления, тем выше вероятность вернуть файлы в полном объёме. ${NC}"
sleep 07

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить R-Studio (r-studio-for-linux-bin) — Восстановление удаленных и поврежденных файлов?"
echo -e "${YELLOW}==> Примечание! ${BOLD} * ${NC}"
echo -e "${MAGENTA}:: ${BOLD}R-Studio — для Linux расширяет семейство мощного и экономичного программного обеспечения для восстановления данных от R-TT до операционной системы Linux. Благодаря гибким параметрам и настраиваемым настройкам R-Studio для Linux пользователи получают абсолютный контроль над своими задачами по восстановлению данных. R-Studio для Linux восстанавливает данные с логических дисков и разделов, а также с дисков и разделов, которые были переформатированы, повреждены или удалены. Помимо дисков с распространенными файловыми системами Linux, R-Studio для Linux восстанавливает файлы с дисков, отформатированных в Windows, FreeBSD/OpenBSD/NetBSD/Solaris и Macintosh. Более того, восстановление файлов в необработанном виде (сканирование известных типов файлов) может использоваться для сильно поврежденных или неизвестных файловых систем. Восстановленные файлы можно сохранять на дисках с любой файловой системой, поддерживаемой ядром Linux (например, ext2, ext3, FAT, NTFS). Этот проект Лицензируется под custom. ${NC}"
echo " Домашняя страница: http://www.r-tt.com/data_recovery_linux/ ; (https://www.r-studio.com/Data_Recovery_Technician.shtml ; https://aur.archlinux.org/packages/r-studio-for-linux-bin ; https://aur.archlinux.org/packages/rtt-rstudio-technician). "
echo -e "${BLUE}:: ${NC}Функции: *R-Studio для Linux восстанавливает файлы: Удалено с компьютера и очищено из корзины ; Повреждено из-за вируса, сбоя питания или внезапного отключения ; С дисков, которые были переформатированы в ту же файловую систему или в другую файловую систему. *Поврежденные и имеющие плохие сектора: R-Studio для Linux создает образ всего диска и восстанавливает его оттуда, чтобы предотвратить дальнейшее физическое повреждение диска. Версия Technician R-Studio для Linux поддерживает два расширенных алгоритма создания образа диска: runtime и multi-pass disk images. Кроме того, R-Studio для Linux поддерживает файлы карты сектора как во внутренних, так и в сторонних форматах. Восстановление данных с поврежденных или удаленных разделов. "
echo -e "${CYAN}:: ${NC}*Поддержка: Диспетчер логических томов Linux (LVM/LVM2) и RAID-массивы mdadm; Windows Storage Spaces (создано обновлением Windows 8/8.1 и 10/Threshold 2/Anniversary); Программные RAID-массивы Apple, CoreStorage, File Vault и Fusion Drive (APFS/HFS+); Шифрование диска Bitlocker, как для томов BitLocker Drive Encryption, так и для томов BitLocker ToGo; Поддерживает базовые и динамические диски (включая несинхронизированные программные RAID-массивы Windows). Поддержка программных RAID-массивов Intel. R-Studio может автоматически распознавать и собирать компоненты этих дисковых менеджеров, даже если их базы данных слегка повреждены. Их компоненты с серьезно поврежденными базами данных могут быть добавлены вручную. Поддержка форматов файлов VMDK/VHD/VHDX/VDI. Только чтение для всех версий, создание для версий Technician/T80+. Поддержка только чтения для файлов dmg (образ диска Apple: все версии), файлов E01/(EWF) (формат файла эксперта-свидетеля: R-Studio Technician/T80+) и файлов AFF (расширенный формат судебной экспертизы: R-Studio Technician/T80+). "
echo -e "${CYAN}:: ${NC}*Поддержка определенных функций файловой системы: Распознавание локализованных имен. Восстановление имен и путей к файлам, удаленным в Корзину и Мусор. Расширенное восстановление Ext2/3/4FS: поддержка жестких ссылок, расширенных атрибутов файлов и журнала файловой системы. Расширенное восстановление UFS: поддержка расширенных атрибутов файлов и журнала обновлений. Расширенное восстановление NTFS: поддержка сжатых и зашифрованных файлов, альтернативных потоков данных, дедупликации, $LogFile, жестких ссылок, соединений каталогов и символических ссылок. Расширенное восстановление ReFS: символические ссылки, соединения каталогов, дедупликация. Расширенное восстановление HFS/HFS+: поддержка сжатых файлов, расширенных атрибутов файлов, жестких ссылок, журнала файловой системы и ветвей ресурсов. Расширенное восстановление APFS: поддержка шифрования. Поддержка соединений каталогов и символических ссылок. "
echo -e "${CYAN}:: ${NC}Установка R-Studio (r-studio-for-linux-bin) и R-Studio Technician (rtt-rstudio-technician) проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/r-studio-for-linux-bin.git), (https://aur.archlinux.org/rtt-rstudio-technician.git) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Установить R-Studio (r-studio-for-linux-bin),  2 - Установить R-Studio Technician (rtt-rstudio-technician),

    0 - НЕТ - Пропустить установку: " in_rstudio  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_rstudio" =~ [^120] ]]
do
    :
done
if [[ $in_rstudio == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_rstudio == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) R-Studio (r-studio-for-linux-bin) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed xdg-utils  # Инструменты командной строки, помогающие приложениям решать различные задачи интеграции с рабочим столом ; https://archlinux.org/packages/extra/any/xdg-utils/ ; https://www.freedesktop.org/wiki/Software/xdg-utils/ ; 2024-02-06 13:02 UTC
######### r-studio-for-linux-bin ###########
yay -S r-studio-for-linux-bin --noconfirm  # (r-studio-for-linux-bin 4.10.4043-1) Программное обеспечение для восстановления данных (платная версия) ; http://www.r-tt.com/data_recovery_linux/ ; https://aur.archlinux.org/r-studio-for-linux-bin.git (только для чтения, нажмите, чтобы скопировать) ; https://aur.archlinux.org/packages/r-studio-for-linux-bin ; https://www.r-studio.com/downloads/RStudio4_x64.deb ; https://aur.archlinux.org/cgit/aur.git/tree/r-studio-for-linux-bin.desktop?h=r-studio-for-linux-bin ; https://aur.archlinux.org/cgit/aur.git/tree/r-studio-for-linux-bin.png?h=r-studio-for-linux-bin ; 2022-02-12 02:34 (UTC)
######### r-studio-for-linux-bin ###########
#git clone https://aur.archlinux.org/r-studio-for-linux-bin.git   # (только для чтения, нажмите, чтобы скопировать)
#cd r-studio-for-linux-bin
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf r-studio-for-linux-bin 
#rm -Rf r-studio-for-linux-bin
  echo ""
  echo " Посмотрите информацию о версии (r-studio) "
sudo pacman -Q r-studio-for-linux-bin  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_rstudio == 2 ]]; then
  echo ""
  echo " Установка утилиты (пакета) R-Studio Technician (rtt-rstudio-technician) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed xdg-utils  # Инструменты командной строки, помогающие приложениям решать различные задачи интеграции с рабочим столом ; https://archlinux.org/packages/extra/any/xdg-utils/ ; https://www.freedesktop.org/wiki/Software/xdg-utils/ ; 2024-02-06 13:02 UTC
######### rtt-rstudio-technician ###########
yay -S rtt-rstudio-technician --noconfirm  # (rtt-rstudio-technician 5.5.191537-1) R-Studio Technician — мощная и экономичная программная утилита для восстановления удаленных и данных (платная) ; https://aur.archlinux.org/packages/rtt-rstudio-technician ; https://aur.archlinux.org/rtt-rstudio-technician.git (только для чтения, нажмите, чтобы скопировать) ; https://www.r-studio.com/Data_Recovery_Technician.shtml ; https://www.r-studio.com/downloads/RStudioTech5_i386.rpm ; https://www.r-studio.com/downloads/RStudioTech5_x64.rpm ; https://www.r-studio.com/includes/eula/PopupEulaDRST.shtml?R-STUDIO%20Technician ; Конфликты: r-studio-technician-for-linux-bin ; Обеспечивает: r-studio-technician-for-linux-bin ; 2025-08-23 20:47 (UTC)
######### rtt-rstudio-technician ###########
#git clone https://aur.archlinux.org/rtt-rstudio-technician.git   # (только для чтения, нажмите, чтобы скопировать)
#cd rtt-rstudio-technician
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf rtt-rstudio-technician
#rm -Rf rtt-rstudio-technician
  echo ""
  echo " Посмотрите информацию о версии (r-studio) "
sudo pacman -Q rtt-rstudio-technician  #  Показать версию приложения
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