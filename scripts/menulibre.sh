#!/usr/bin/env bash
# Install script menulibre
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
# wget git.io/menulibre.sh && sh menulibre.sh

echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git

echo -e "${MAGENTA}
  <<< Установка Редактора меню программ (пакетов) в Archlinux >>> ${NC}"
# Installing the program (package) menu Editor in Archlinux

echo ""
echo -e "${GREEN}==> ${NC}Установить редактор главного меню программ (пакетов)?"
#echo -e "${BLUE}:: ${NC}Установить редактор меню программ (пакетов)?"
#echo 'Установить редактор меню программ (пакетов)?'
# Install the program (package) menu editor?
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют следующий вариант: ${NC}"
echo -e "${MAGENTA}:: ${NC}1 - MenuLibre - удобный инструмент, Python / GTK графическая утилита для редактирования меню приложений в графических рабочих окружениях Gnome, LXDE, XFCE и Unity, предоставляя несколько дополнительных возможностей не имеющихся в стандартных для окружений "Редакторах меню" (те которые их имеют и сторонних)."
echo " MenuLibre в удобном и интуитивно понятном пользовательском интерфейсе создавать/изменять/удалять пункты меню, изменять категории приложений, просматривать/изменять команды запуска, менять описание и др... "
echo -e "${CYAN}:: ${NC}Установка menulibre проходит через сборку из исходников AUR. То есть установка производиться с помощью git clone (https://aur.archlinux.org/menulibre.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/menulibre/), собирается и устанавливается."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить редактора меню - MenuLibre,

    0 - НЕТ - Пропустить установку: " in_menu  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_menu" =~ [^10] ]]
do
    :
done
if [[ $in_menu == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_menu == 1 ]]; then
  #echo ""
  #echo " Обновление баз данных пакетов, и системы через - AUR (Yay) "
  #yay -Syy
  #yay -Syu
echo ""
echo " Установка Редактора меню - MenuLibre "	
##### menulibre ######
# yay -S menulibre --noconfirm  # Расширенный редактор меню, который предоставляет современные функции в чистом, простом в использовании интерфейсе
git clone https://aur.archlinux.org/menulibre.git 
cd menulibre
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf menulibre
rm -Rf menulibre   # удаляем директорию сборки
echo ""
echo " Установка утилит (пакетов) выполнена "
echo " Желательно перезагрузить систему для применения изменений "
fi

clear

# Успех
#Success
echo "Установка завершена! Перезагрузить."
#echo "Installation complete! Reboot."


# -------------------------------------------------

# Если в системе не установлены необходимые зависимости, makepkg предупредит вас об этом и отменит сборку. Если задать флаг -s/--syncdeps, то makepkg самостоятельно установит недостающие зависимости и соберёт пакет.
# $ makepkg --syncdeps

# ---------------------------------------------------

#
# https://aur.archlinux.org/packages/git-hub/
# URL-адрес клона Git:	https://aur.archlinux.org/menulibre.git (только для чтения, нажмите, чтобы скопировать)
# База пакета:	menulibre
# Описание:	Расширенный редактор меню, который предоставляет современные функции в чистом и простом в использовании интерфейсе.
# Восходящий URL-адрес:	https://github.com/bluesabre/menulibre
# Ключевые слова:	редактор гном меню
# Лицензии:	GPL3
# Отправитель:	Ner0
# Сопровождающий:	jonian
# Последний упаковщик: jonian
# Голоса:	212
# Популярность:	0,35
# Впервые отправлено:	2012-07-10 05:32 (UTC)
# Последнее обновление:	2024-03-04 13:45 (UTC)

# <<< Делайте выводы сами! >>>
#
