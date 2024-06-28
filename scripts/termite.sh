#!/usr/bin/env bash
# Install script termite
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
# wget git.io/termite.sh && sh termite.sh

echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git

clear
echo ""
echo -e "${MAGENTA}:: ${NC}Установка дополнительных базовых программ (пакетов) - которые раньше присутствовали в (community), но были перенесены в репозиторий AUR .... "
  #echo ""
  #echo " Обновление баз данных пакетов, и системы через - AUR (Yay) "
  #yay -Syy
  #yay -Syu
########### autofs #############
  echo ""
  echo " Установка Средства автомонтирования на основе ядра для Linux (autofs) "
  git clone https://aur.archlinux.org/autofs.git  # Средство автомонтирования на основе ядра для Linux
  cd autofs
  makepkg -si --noconfirm
  pwd
# makepkg -si
#makepkg -si --skipinteg
  cd ..
  rm -Rf autofs
  echo ""
  echo " Установка пакета (autofs) завершена "
########## davfs2 ############
  echo ""
  echo " Установка Драйвера файловой системы (davfs2) "
  git clone https://aur.archlinux.org/davfs2.git   # Драйвер файловой системы, позволяющий монтировать папку WebDAV
  cd davfs2
  makepkg -si --noconfirm
  pwd
# makepkg -si
#makepkg -si --skipinteg
  cd ..
  rm -Rf davfs2
  echo ""
  echo " Установка пакета (davfs2) завершена "
####### termite #######
# sudo pacman -S termite --noconfirm  #  Простой терминал на базе VTE
# sudo pacman -S termite-terminfo --noconfirm  # Terminfo для Termite, простого терминала на базе VTE
  echo ""
  echo " Установка терминал на базе VTE (termite) "
  git clone https://aur.archlinux.org/termite.git   #  Простой терминал на базе VTE
  cd termite
  makepkg -si --noconfirm
  pwd
# makepkg -si
#makepkg -si --skipinteg
  cd ..
  rm -Rf termite
  echo ""
  echo " Установка пакета (termite) завершена "
########
clear
echo ""
echo " Установка дополнительных базовых программ (пакетов) выполнена "
echo ""
echo " Запускаем обслуживания gpm сервера мыши для консоли и xterm "
sudo systemctl start gpm
echo ""
echo " Добавляем службу gpm в автозагрузку "
sudo systemctl enable gpm
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
# <<< Делайте выводы сами! >>>

