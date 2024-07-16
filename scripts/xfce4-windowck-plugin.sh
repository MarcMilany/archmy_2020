#!/usr/bin/env bash
# Install script xfce4-docklike-plugin
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
# wget git.io/xfce4-docklike-plugin.sh && sh xfce4-docklike-plugin.sh

echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git

echo ""
echo -e "${GREEN}==> ${NC}Установить Xfce4-Windowck-плагин для XFCE?"
echo -e "${MAGENTA}:: ${BOLD}Xfce4-Windowck-plugin - Плагин Windowsck - это набор из трех плагинов, позволяющий размещать на панели кнопки, заголовок и меню активных или развернутых окон. ${NC}"
echo " Плагин панели Xfce, позволяющий размещать кнопки, заголовок и меню активных или развернутых окон на панели. Этот код взят из Window Applets Андрея Бельцияна (http://gnome-look.org/content/show.php?content=103732). Домашняя страница: https://docs.xfce.org/panel-plugins/xfce4-windowck-plugin/start "
echo -e "${YELLOW}==> Примечание! ${NC}Добавьте на панель нужные плагины заголовков окон. Вы можете задать поведение и внешний вид в диалоговом окне свойств (управляемые окна, кнопки отображения/скрытия, тема, параметры форматирования заголовка…). "
echo " Функции: Отображать заголовок, кнопки и меню развернутых окон на панели. Разрешить действия с окнами при нажатии кнопок и заголовков (активировать, (раз)развернуть, закрыть). Разрешить меню действий окна при нажатии левой кнопки мыши. Параметры форматирования заголовка. Поддержка тем Xfwm4/Unity для кнопок. "
echo -e "${CYAN}:: ${NC}Установка Xfce4-Windowck-plugin (xfce4-windowck-plugin-git) проходит через сборку из исходников. То есть установка производиться с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/xfce4-windowck-plugin-git.git) ; (https://gitlab.xfce.org/panel-plugins/xfce4-windowck-plugin/)- собирается и устанавливается. "
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
# Be careful! The installation process, after the option you selected, was registered fully automatic. In this option, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_windowck  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_windowck" =~ [^10] ]]
do
    :
done
if [[ $i_windowck == 0 ]]; then
echo ""
echo " Установка Docklike Plugin пропущена "
elif [[ $i_windowck == 1 ]]; then
  #echo ""
  #echo " Обновление баз данных пакетов, и системы через - AUR (Yay) "
  #yay -Syy
  #yay -Syu
  echo ""
  echo " Установка Xfce4-Windowck-plugin (xfce4-windowck-plugin-git) "  
#### xfce4-windowck-plugin-git #######
#yay -S xfce4-windowck-plugin-git --noconfirm  # Плагин панели Xfce для отображения заголовка окна и кнопок
# https://aur.archlinux.org/xfce4-windowck-plugin-git.git (только для чтения, нажмите, чтобы скопировать) ; 
# https://gitlab.xfce.org/panel-plugins/xfce4-windowck-plugin/ ; https://aur.archlinux.org/packages/xfce4-windowck-plugin-git ; https://docs.xfce.org/panel-plugins/xfce4-windowck-plugin/start
git clone https://aur.archlinux.org/xfce4-windowck-plugin-git.git
cd xfce4-windowck-plugin-git
# cd xfce4-windowck-plugin-git
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf xfce4-windowck-plugin-git
rm -Rf xfce4-windowck-plugin-git
# rm -Rf xxfce4-windowck-plugin-git
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear

# Успех
#Success
echo "Установка завершена! Перезагрузить."
#echo "Installation complete! Reboot."

# <<< Делайте выводы сами! >>>
#
