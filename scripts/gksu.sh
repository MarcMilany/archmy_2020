#!/usr/bin/env bash
# Install script gksu
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
# wget git.io/gksu.sh && sh gksu.sh

echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git

clear
echo ""
######### Gksu ###############
echo -e "${RED}
 ==> Внимание! ${BOLD}Если Вы установили Графический менеджер пакетов (octopi), то СОВЕТУЮ пропустить установку Gksu. Так как в сценарии установки Pacman gui (octopi), уже прописана установка пакетов (gksu) и (libgksu). ${NC}"
echo -e "${YELLOW}==> Примечание: ${NC}Сейчас Вы можете установить "Gksu", или пропустите установку."
echo ""
echo -e "${GREEN}==> ${NC}Установить Gksu - Графический интерфейс для su"
#echo -e "${BLUE}:: ${NC}Установить Gksu - Графический интерфейс для su"
#echo 'Установить Gksu - Графический интерфейс для su'
# To install Gksu - Graphical UI for subversion
echo " Ставим пакет (gksu) - графический интерфейс для su, и пакет (libgksu) - библиотека авторизации gksu "
echo -e "${MAGENTA}:: ${BOLD}Для запуска графических приложений от имени суперпользователя существуют специальные утилиты. Они сохраняют все необходимые переменные окружения и полномочия. В KDE это команда kdesu, а в Gnome,Xfce,... - команда gksu (gksu nautilus). ${NC}"
echo " Программа запросит пароль, уже в графическом окне, а потом откроется файловый менеджер. "
echo " Теперь программы, требующие дополнительных привилегий в системе, не вызовут у вас проблем. "
echo -e "${CYAN}:: ${NC}Установка Gksu (gksu), и (libgksu), проходит через сборку из исходников. То есть установка производиться с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/gksu/), (https://aur.archlinux.org/packages/libgksu/), (https://aur.archlinux.org/packages/gconf.git/)-(это зависимость для libgksu) - собирается и устанавливается. "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. В данной опции выбор остаётся за вами. "
# Be careful! The installation process was fully automatic. In this option, the choice is yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да установить, 0 - НЕТ - Пропустить установку: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " prog_set  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$prog_set" =~ [^10] ]]
do
    :
done
if [[ $prog_set == 0 ]]; then
# clear
  echo ""
  echo " Установка графического интерфейса для su (gksu) пропущена "
elif [[ $prog_set == 1 ]]; then
  echo ""
  echo " Установка gconf - зависимость для libgksu "
  git clone https://aur.archlinux.org/gconf.git  # Устаревшая система базы данных конфигурации 
  cd gconf
#makepkg -fsri
# makepkg -si
  makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
  pwd    # покажет в какой директории мы находимся
  cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf gconf
  rm -Rf gconf
############ libgksu ##########
  echo ""
  echo " Установка libgksu - библиотека авторизации gksu "
  git clone https://aur.archlinux.org/libgksu.git  
  cd libgksu
#makepkg -fsri
# makepkg -si
  makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
  pwd    # покажет в какой директории мы находимся
  cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf libgksu
  rm -Rf libgksu
############ gksu ##########
  echo ""
  echo " Установка gksu - Графический интерфейс для su "
  sudo pacman -S --noconfirm --needed xorg-xauth  # Программа настройки авторизации X.Org
# sudo pacman -S xorg-xauth --noconfirm  # Программа настройки авторизации X.Org
  git clone https://aur.archlinux.org/gksu.git
  cd gksu
#makepkg -fsri
# makepkg -si
  makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
  pwd    # покажет в какой директории мы находимся
  cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf gksu
  rm -Rf gksu
# clear
  echo ""
  echo " Графический интерфейс для su (gksu) успешно установлен! "
fi
# ----------------------------------------------------
# Права суперпользователя Linux
# https://losst.ru/prava-superpolzovatelya-linux
# Gksu и libgksu:
# https://aur.archlinux.org/packages/libgksu/
# https://aur.archlinux.org/packages/gksu/
# ==================================================

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
# <<< Делайте выводы сами! >>>

