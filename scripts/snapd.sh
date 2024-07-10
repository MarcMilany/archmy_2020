#!/usr/bin/env bash
# Install script snapd
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
# wget git.io/snapd.sh && sh snapd.sh

echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Snap на Arch Linux?"
#echo -e "${BLUE}:: ${NC}Установить Snap на Arch Linux?"
#echo 'Установить Snap на Arch Linux?'
# To install Snap-on Arch Linux?
echo -e "${MAGENTA}:: ${BOLD}Snap - это инструмент для развертывания программного обеспечения и управления пакетами,  которые обновляются автоматически, просты в установке, безопасны, кроссплатформенны и не имеют зависимостей. Изначально разработанный и созданный компанией Canonical, который работает в различных дистрибутивах Linux каждый день. ${NC}"
echo -e "${CYAN}:: ${NC}Для управления пакетами snap, установим snapd (демон), а также snap-confine, который обеспечивает монтирование, изоляцию и запуск snap-пакетов."
echo " Установка происходит из 'AUR'- с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/snapd.git)."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. В любой ситуации выбор всегда остаётся за вами. "
# Be careful! The installation process was fully automatic. In any situation, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да установить, 0 - НЕТ - Пропустить установку: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_snap  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_snap" =~ [^10] ]]
do
    :
done
if [[ $i_snap == 0 ]]; then
echo ""
echo " Установка Snap пропущена "
elif [[ $i_snap == 1 ]]; then
echo ""
#echo -e " Установка базовых программ и пакетов wget, curl, git "
#sudo pacman -S --noconfirm --needed wget curl git
  #echo ""
  #echo " Обновление баз данных пакетов, и системы через - AUR (Yay) "
  #yay -Syy
  #yay -Syu
###### SNAP ##############
echo " Установка поддержки Snap "
git clone https://aur.archlinux.org/snapd.git
cd snapd
# makepkg -si
makepkg -si --skipinteg
#makepkg -si --noconfirm  #-не спрашивать каких-либо подтверждений
cd ..
rm -Rf snapd
clear
echo ""
echo " Установка Snapd выполнена "
#fi
########## Запускаем поддержку Snap ###############
echo ""
echo -e "${BLUE}:: ${NC}Включить модуль systemd, который управляет основным сокетом мгновенной связи"
sudo systemctl enable --now snapd.socket
# Проверить статус сервиса:
# systemctl status snapd.socket
echo ""
echo -e "${BLUE}:: ${NC}Включить поддержку классической привязки, чтобы создать символическую ссылку между /var/lib/snapd/ snap и /snap"
sudo ln -s /var/lib/snapd/snap /snap
echo ""
echo -e "${BLUE}:: ${NC}Поскольку бинарный файл находится в каталоге /snap/bin/, нужно добавить его в переменную $PATH."
echo "export PATH=\$PATH:\/snap/bin/" | sudo tee -a /etc/profile
source /etc/profile
echo ""
echo " Snapd теперь готов к использованию "
echo " Вы взаимодействуете с ним с помощью команды snap. "
# Посмотрите страницу помощи команды:
# snap --help
echo ""
echo -e "${BLUE}:: ${NC}Протестируем систему, установив hello-world snap и убедимся, что она работает правильно."
#sudo snap install hello-world
snap install hello-world
hello-world
echo ""
echo -e "${BLUE}:: ${NC}Список установленных snaps:"
snap list
echo -e "${BLUE}:: ${NC}Удалить установленный snap (hello-world)"
sudo snap remove hello-world
echo ""
echo " Snap теперь установлен и готов к работе! "
echo ""
echo " Установка утилит (пакетов) выполнена "
echo " Желательно перезагрузить систему для применения изменений "
fi

sleep 03

clear

# Успех
#Success
echo "Установка завершена! Перезагрузить."
#echo "Installation complete! Reboot."

# -------------------------------------------------

# Если в системе не установлены необходимые зависимости, makepkg предупредит вас об этом и отменит сборку. Если задать флаг -s/--syncdeps, то makepkg самостоятельно установит недостающие зависимости и соберёт пакет.
# $ makepkg --syncdeps

# ---------------------------------------------------
# URL-адрес клона Git: https://aur.archlinux.org/snapd.git  (только чтение, нажмите, чтобы скопировать)
# База пакета:  snapd
# Описание: Сервис и инструменты для управления снап-пакетами.
# Восходящий URL-адрес: https://github.com/snapcore/snapd
# Лицензии: GPL3
# Отправитель:  Barthalion
# Сопровождающий: bboozzoo (zyga, mardy)
# Последний упаковщик:  bboozzoo
# Голоса: 210
# Популярность: 0.86
# Впервые отправлено: 2018-01-07 17:37 (UTC)
# Последнее обновление: 2024-05-23 11:20 (UTC)
# --------------------------------------#

# <<< Делайте выводы сами! >>>

