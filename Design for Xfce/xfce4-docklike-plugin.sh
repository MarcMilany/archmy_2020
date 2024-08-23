#!/usr/bin/env bash
# Install script xfce4-docklike-plugin
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
# wget git.io/xfce4-docklike-plugin.sh && sh xfce4-docklike-plugin.sh

echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git

echo ""
echo -e "${GREEN}==> ${NC}Установить Docklike Plugin для XFCE?"
echo -e "${MAGENTA}:: ${BOLD}Docklike Plugin - это современная минималистичная панель задач в стиле док-станции для Xfce. Используя его на рабочем столе Xfce, Вы получите "панель задач - только значки" с поддержкой прикрепления приложений и группировкой окон. ${NC}"
echo " Этот плагин панели Xfce является отличной альтернативой DockBarX, с меньшим количеством функций и настроек. "
echo -e "${YELLOW}==> Примечание! ${NC}Помимо того, что плагин позволяет запустить/закрыть окно приложения, минимизировать в один клик на панели, он также может управлять параметрами открытых окон из значка. Используйте Ctrl, чтобы изменить порядок приложений или получить доступ к панели настроек (щелкнув правой кнопкой мыши)."
echo " Как отмечалось в начале, плагин обладает небольшим количеством функций и настроек. "
echo -e "${CYAN}:: ${NC}Установка Docklike Plugin (xfce4-docklike-plugin-git) ; (xfce4-docklike-plugin) проходит через сборку из исходников. То есть установка производиться с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/xfce4-docklike-plugin-git/) ; (https://aur.archlinux.org/packages/xfce4-docklike-plugin/)- собирается и устанавливается. "
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
# Be careful! The installation process, after the option you selected, was registered fully automatic. In this option, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_docklike  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_docklike" =~ [^10] ]]
do
    :
done
if [[ $i_docklike == 0 ]]; then
echo ""
echo " Установка Docklike Plugin пропущена "
elif [[ $i_docklike == 1 ]]; then
  #echo ""
  #echo " Обновление баз данных пакетов, и системы через - AUR (Yay) "
  #yay -Syy
  #yay -Syu
  echo ""
  echo " Установка Docklike Plugin (xfce4-docklike-plugin) "  
#### xfce4-docklike-plugin #######
#yay -S xfce4-docklike-plugin --noconfirm  # Современная минималистичная панель задач в стиле док-станции для XFCE
#yay -S xfce4-docklike-plugin-git --noconfirm  # Панель задач Docklike (Если установлен yay - эта команда)
git clone https://aur.archlinux.org/xfce4-docklike-plugin.git
# git clone https://aur.archlinux.org/xfce4-docklike-plugin-git.git
cd xfce4-docklike-plugin
# cd xfce4-docklike-plugin-git
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf xfce4-docklike-plugin
rm -Rf xfce4-docklike-plugin
# rm -Rf xfce4-docklike-plugin-git
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#-------------------------
# Важно!!!
# Нужно удерживать ctrl, чтобы изменить порядок закрепленных приложений.
# (Я подумал, что было бы неплохо упомянуть эту информацию. Я нашел это в проекте README как раз перед тем, как собирался открепить все и переставить их с нуля.)
# https://aur.archlinux.org/packages/xfce4-docklike-plugin-git/
# https://aur.archlinux.org/packages/xfce4-docklike-plugin/
# https://github.com/nsz32/docklike-plugin
# https://github.com/topics/xfce4-panel-plugin
# https://compizomania.blogspot.com/2020/12/docklike-plugin-xfce.html
#------------------------------

clear

# Успех
#Success
echo "Установка завершена! Перезагрузить."
#echo "Installation complete! Reboot."


# -------------------------------------------------

# Если в системе не установлены необходимые зависимости, makepkg предупредит вас об этом и отменит сборку. Если задать флаг -s/--syncdeps, то makepkg самостоятельно установит недостающие зависимости и соберёт пакет.
# $ makepkg --syncdeps

# ---------------------------------------------------
# URL-адрес клона Git:  https://aur.archlinux.org/xfce4-docklike-plugin.git (только чтение, нажмите, чтобы скопировать)
# База пакета:  xfce4-docklike-plugin
# Описание: Современная, минималистичная панель задач в стиле док для XFCE
# Восходящий URL-адрес: https://gitlab.xfce.org/panel-plugins/xfce4-docklike-plugin
# Лицензии: GPL3
# Конфликты:  xfce4-docklike-plugin-git, xfce4-docklike-plugin-ng-git
# Отправитель:  hayao
# Сопровождающий: Tio (shoryuken)
# Последний упаковщик:  Tio
# Голоса: 17
# Популярность: 0,116217
# Впервые отправлено: 2021-03-14 08:20 (UTC)
# Последнее обновление: 2024-01-23 02:01 (UTC)

# <<< Делайте выводы сами! >>>
#
