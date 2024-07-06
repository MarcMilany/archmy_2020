#!/usr/bin/env bash
# Install script sblock
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
# wget git.io/sblock.sh && sh sblock.sh

echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git

clear
echo -e "${MAGENTA}
  <<< Установка дополнительного программного обеспечения (пакетов) для повышения безопасности и конфиденциальности в Archlinux >>> ${NC}"
# Installing additional software (packages) to improve security and privacy in Archlinux

echo ""
echo -e "${GREEN}==> ${NC}Установка sBlock из AUR (повысьте свою безопасность и конфиденциальность, заблокировав рекламу, отслеживание и вредоносные домены)"
#echo -e "${BLUE}:: ${NC}Установка sBlock (повысьте свою безопасность и конфиденциальность, заблокировав рекламу, отслеживание и вредоносные домены)"
#echo 'Установка sBlock'
# Installing sBlock (increase your security and privacy by blocking ads, tracking, and malicious domains)
echo -e "${MAGENTA}=> ${BOLD}sBlock - это POSIX-совместимый сценарий оболочки, который получает список доменов, которые обслуживают рекламу, сценарии отслеживания и вредоносное ПО из нескольких источников, и создает файл hosts, среди других форматов, который предотвращает подключение вашей системы к ним. ${NC}"
echo -e "${CYAN}:: ${NC}Установка sblock-git проходит через сборку из исходников AUR. То есть установка производиться с помощью git clone (https://aur.archlinux.org/sblock-git.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/sblock-git/), собирается и устанавливается."
echo -e "${MAGENTA}==> Примечание: ${NC}Желательно установить пакет (termite - https://www.archlinux.org/packages/community/x86_64/termite/ - Простой терминал на базе VTE), так как обновление списка доменов в файле hosts - проходит через терминал! hBlock доступен в различных менеджерах пакетов..."
echo -e "${YELLOW}==> Применение: ${BOLD}Поведение sBlock по умолчанию можно настроить с помощью нескольких параметров. Воспользуйтесь --help опцией или проверьте полный список в файле sblock.1.md - (при скачивании и установке с сайта https://github.com/koonix/sblock). ${NC}"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_sblock  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_sblock" =~ [^10] ]]
do
    :
done
if [[ $i_sblock == 0 ]]; then
echo ""
echo " Установка hBlock из AUR пропущена "
elif [[ $i_sblock == 1 ]]; then
##### hblock ######
  echo ""
  echo " Создание backup файла /etc/hosts в директории исходника "
  echo " В дальнейшем Вы можете удалить файл hosts_orig.backup, от имени суперпользователя (root) без последствий! "
sudo cp -vf /etc/hosts /etc/hosts_orig.backup
  #echo ""
  #echo " Обновление баз данных пакетов, и системы через - AUR (Yay) "
  #yay -Syy
  #yay -Syu
echo " Установка hBlock из AUR "
# yay -S sblock --noconfirm  # Простой блокировщик рекламы, который создает файл хостов из нескольких источников, аналогичный hblock.
# yay -Rns sblock-git # * (Необязательно) Удалите sblock-git в Arch с помощью YAY.
git clone https://aur.archlinux.org/sblock-git.git 
cd sblock-git
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf sblock-git
rm -Rf sblock-git   # удаляем директорию сборки
echo ""
echo " Установка утилит (пакетов) выполнена "
echo " Желательно перезагрузить систему для применения изменений "
fi
# ------------------------------
# Отключаем IPv6
# Для этого создадим новый файл /etc/sysctl.d/10-ipv6.conf с содержимым:
# net.ipv6.conf.all.disable_ipv6 = 1
# ===============================
echo ""
echo " Установка утилит (пакетов) выполнена "
echo " Желательно перезагрузить систему для применения изменений "
fi

sleep 2

clear

# Успех
#Success
echo "Установка завершена! Перезагрузить."
#echo "Installation complete! Reboot."

# -------------------------------------------------

# Если в системе не установлены необходимые зависимости, makepkg предупредит вас об этом и отменит сборку. Если задать флаг -s/--syncdeps, то makepkg самостоятельно установит недостающие зависимости и соберёт пакет.
# $ makepkg --syncdeps

# ---------------------------------------------------
# URL-адрес клона Git: https://aur.archlinux.org/sblock-git.git  (только чтение, нажмите, чтобы скопировать)
# База пакета:  sblock-git
# Описание: Простой блокировщик рекламы, который создает файл хостов из нескольких источников, аналогичный hblock.
# Восходящий URL-адрес: https://github.com/koonix/sblock
# Лицензии: GPL
# Отправитель:  koonix
# Сопровождающий: koonix
# Последний упаковщик:  koonix
# Голоса: 1
# Популярность: 0,000005
# Впервые отправлено: 2021-12-26 14:46 (UTC)
# Последнее обновление: 2023-04-24 09:31 (UTC)
# --------------------------------------#

# <<< Делайте выводы сами! >>>

