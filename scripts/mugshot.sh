#!/usr/bin/env bash
# Install script mugshot
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
# wget git.io/mugshot.sh && sh mugshot.sh

echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git

clear
echo -e "${MAGENTA}
  <<< Установка дополнительного программного обеспечения (пакетов) для обновления личных данных пользователя в Archlinux >>> ${NC}"
# Installing additional software (packages) for updating the user's personal data in Archlinux

echo ""
echo -e "${GREEN}==> ${NC}Установка Mugshot из AUR (настройка личных данных пользователя)"
#echo -e "${BLUE}:: ${NC}Установка Mugshot из AUR (настройка личных данных пользователя)"
#echo 'Установка Mugshot из AUR (настройка личных данных пользователя)'
# Installing Mugshot from AUR (configuring user's personal data)
echo -e "${MAGENTA}=> ${BOLD}Mugshot - это облегченная утилита настройки пользователя для Linux, разработанная для простоты и легкости использования. Быстро обновляйте свой личный профиль и синхронизируйте обновления между приложениями. ${NC}"
echo -e "${MAGENTA}==> Примечание: ${NC}В обновляемую информацию личного профиля входят: - Изображение профиля Linux: ~ / .face и AccountService; Данные пользователя хранятся в / etc / passwd (используется finger и другими настольными приложениями); (Необязательно) Синхронизация изображение своего профиля со значком Pidgin; (Необязательно) Синхронизация данных пользователя с LibreOffice и т.д..."
echo -e "${CYAN}:: ${NC}Установка mugshot проходит через сборку из исходников AUR. То есть установка производиться с помощью git clone (https://aur.archlinux.org/mugshot.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/mugshot), собирается и устанавливается."
echo -e "${YELLOW}==> Примечание: ${BOLD}Если вы используете рабочее окружение Xfce, то желательно установить пакет (xfce4-whiskermenu-plugin - Меню для Xfce4 - https://www.archlinux.org/packages/community/x86_64/xfce4-whiskermenu-plugin/, если таковой не был установлен изначально). ${NC}"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_mugshot  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_mugshot" =~ [^10] ]]
do
    :
done
if [[ $i_mugshot == 0 ]]; then
echo ""
echo " Установка Mugshot из AUR пропущена "
elif [[ $i_mugshot == 1 ]]; then
  #echo ""
  #echo " Обновление баз данных пакетов, и системы через - AUR (Yay) "
  #yay -Syy
  #yay -Syu
##### mugshot ######
  echo ""
  echo " Установка Mugshot из AUR (для настройки личных данных пользователя) "
# sudo pacman -S xfce4-whiskermenu-plugin --noconfirm  # Меню для Xfce4
# yay -S mugshot --noconfirm  # Программа для обновления личных данных пользователя
git clone https://aur.archlinux.org/mugshot.git
cd mugshot
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf mugshot
rm -Rf mugshot   # удаляем директорию сборки
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
# URL-адрес клона Git:  https://aur.archlinux.org/mugshot.git (только чтение, нажмите, чтобы скопировать)
# База пакета:  mugshot
# Описание: Программа для обновления личных данных пользователя
# Восходящий URL-адрес: https://github.com/bluesabre/mugshot
# Лицензии: GPLv3
# Отправитель:  None
# Сопровождающий: twa022
# Последний упаковщик:  twa022
# Голоса: 101
# Популярность: 0,46
# Впервые отправлено: 2014-10-06 21:37 (UTC)
#Последнее обновление: 2022-09-06 01:38 (UTC)
# --------------------------------------#
# checkrebuild -v
# foreign mugshot
# /usr/lib/python3.11/ is owned by mugshot 0.4.3-3
# ------------------------------------#
# <<< Делайте выводы сами! >>>

