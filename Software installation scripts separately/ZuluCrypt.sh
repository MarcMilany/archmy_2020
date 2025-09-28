#!/usr/bin/env bash
# Install script ZuluCrypt
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

ZuluCrypt_LANG="russian"  # Installer default language (Язык установки по умолчанию)

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
echo -e "${BLUE}:: ${NC}Установить ZuluCrypt (zulucrypt) - Интерфейс cli и gui для cryptsetup (шифрования жестких дисков)?"
echo -e "${MAGENTA}:: ${BOLD}zuluCrypt — это основанный на Qt графический интерфейс и cli-решение для управления зашифрованными томами LUKS, PLAIN, TRUECRYPT, VERACRYPT и Microsoft BITLOCKER.zuluMount — это инструмент, который можно использовать для монтирования и размонтирования разделов, а также для открытия и закрытия зашифрованных томов. Он делает то же, что udisks и его друзья, но без механизма аутентификации polkit или d-bus. 🔐 ${NC}"
echo " Домашняя страница: https://mhogomchungu.github.io/zuluCrypt ; (https://aur.archlinux.org/packages/zulucrypt). "  
echo -e "${MAGENTA}:: ${BOLD}Работа в ZuluCrypt: Одно из первых дел, которые надо сделать после установки — создать шифрованные версии всех файлов, которые вы считаете конфиденциальными. Запустите приложение и выберите: zC > Encrypt A File . В появившемся диалоговом окне нажмите на кнопку рядом с полем Source и выберите файл, который требуется зашифровать. ZuluCrypt использует эту информацию, чтобы создать файл с тем же именем, и добавит в конце расширение zC; или же сохраните его в другом месте, нажав на значок папки рядом с полем Destination и выбрав новое местоположение. Далее введите пароль для шифрования файла в поле key. Пароль должен представлять собой смесь из букв и цифр, чтобы его было сложно угадать. Также помните, что нет средства восстановления пароля, если вы его забудете, и нет возможности расшифровки файла — это информация к размышлению! После подтверждения пароля нажмите кнопку Create для шифрования файлов. Время, требуемое на этот процесс, зависит от типа и размера шифруемого файла. По окончании у вас будет шифрованная версия с расширением .zC в указанном вами месте. Раз файл был зашифрован, позаботьтесь удалить его оригинал. Теперь, чтобы читать этот файл и вносить в него изменения, его надо будет расшифровать. Для этого запустите ZuluCrypt и выберите: zC > Decrypt A File . Укажите зашифрованный файл в поле Source и измените расположение разблокированного файла в поле Destination. Затем введите пароль, с которым файл шифровался, и нажмите на кнопку Create. В указанном месте назначения создастся расшифрованный файл. Чтобы снова заблокировать файл, зашифруйте его, выполнив описанные выше процедуры (https://spy-soft.net/zulucrypt/). ${NC}"
echo " zuluCrypt может выполнять следующие действия, среди прочего: Создавать файлы ключей размером 64 байта, состоящие только из 94 печатных символов. Создавать зашифрованные тома как в файлах, так и в разделах. Создавать зашифрованные тома типов plain, luks, а также truecrypt. Добавлять ключи в тома на основе luks. Удалять ключи из томов на основе luks luks. Открывать тома на основе plain, luks и truecrypt, находящиеся как в файлах, так и в разделах. Шифровать отдельные файлы. Стирать данные на разделах, т. е. может использоваться как инструмент для стирания данных. Для получения дополнительной информации прочтите раздел 2,3,4 и 5 в FAQ, расположенном по адресу: http://code.google.com/p/zulucrypt/wiki/FAQ . " 
echo -e "${CYAN}:: ${NC}Установка ZuluCrypt (zulucrypt) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_zulucrypt  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_zulucrypt" =~ [^10] ]]
do
    :
done
if [[ $in_zulucrypt == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_zulucrypt == 1 ]]; then
  echo ""
  echo " Установка ZuluCrypt (zulucrypt) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
######### zulucrypt ##########
yay -S zulucrypt --noconfirm  # Интерфейс cli и gui для cryptsetup ; https://aur.archlinux.org/zulucrypt.git (только для чтения, нажмите, чтобы скопировать) ; https://mhogomchungu.github.io/zuluCrypt ; https://github.com/mhogomchungu/zuluCrypt/releases/download/7.0.0/zuluCrypt-7.0.0.tar.xz ; 2024-08-21 09:06 (UTC) ; https://store.kde.org/p/1131754/ ; Конфликты: с zulucrypt-git; Смотрите Зависимости !
#git clone https://aur.archlinux.org/zulucrypt.git   # (только для чтения, нажмите, чтобы скопировать)
#cd zulucrypt
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf zulucrypt 
#rm -Rf zulucrypt
# yay -Rns zulucrypt  # * (Необязательно) Удалите Zulucrypt на Arch с помощью YAY
###########
# Ключ подписи можно получить с помощью следующей команды:
# gpg --recv-keys 0x02FC64E8DEBF43A8
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
##########
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

