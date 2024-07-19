#!/usr/bin/env bash
# Install script pacman-contrib
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
# wget git.io/pacman-contrib.sh && sh pacman-contrib.sh

echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git

clear
echo ""
echo -e "${BLUE}:: ${NC}Установим дополнения (плюшки) для Pacman - пакет (pacman-contrib)?"
echo " Этот репозиторий содержит скрипты, предоставленные pacman (различных дополнений и приятных мелочей для более комфортной работы сполна) "
echo -e "${YELLOW}=> Примечание: ${BOLD}Раньше это было частью pacman.git, но было перемещено, чтобы упростить обслуживание pacman. Также, вместе с пакетом (pacman-contrib) будет установлен пакет (pcurses) - инструмент управления пакетами curses с использованием libalpm. ${NC}"
echo " Скрипты, доступные в этом репозитории: checkupdates, paccache, pacdiff, paclist, paclog-pkglist, pacscripts, pacsearch, rankmirrors, updpkgsums;... "
echo " checkupdates - распечатать список ожидающих обновлений, не касаясь баз данных синхронизации системы (для безопасности при скользящих выпусках). "
echo " paccache - гибкая утилита очистки кэша пакетов, которая позволяет лучше контролировать, какие пакеты удаляются. "
echo " pacdiff - простая программа обновления pacnew / pacsave для / etc /. "
echo " paclist - список всех пакетов, установленных из данного репозитория. Полезно, например, для просмотра того, какие пакеты вы могли установить из тестового репозитория. "
echo " paclog-pkglist - выводит список установленных пакетов на основе журнала pacman. "
echo " pacscripts - пытается распечатать сценарии {pre, post} _ {install, remove, upgrade} для данного пакета. "
echo " pacscripts - пытается распечатать сценарии {pre, post} _ {install, remove, upgrade} для данного пакета. "
echo " pacsearch - цветной поиск, объединяющий вывод -Ss и -Qs. Установленные пакеты легко идентифицировать с помощью [installed] значка, и также перечислены только локальные пакеты. "
echo " rankmirrors - ранжирует зеркала pacman по скорости подключения и скорости открытия. "
echo " updpkgsums - выполняет обновление контрольных сумм в PKGBUILD на месте. "
echo -e "${YELLOW}==> ${NC}Будьте внимательны! Если Вы сомневаетесь в своих действиях, просто пропустите этот пункт."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить пакет (pacman-contrib),    0 - Нет пропустить установку: " i_contrib  # sends right after the keypress; # отправляет сразу после нажатия клавиши
echo ''
   [[ "$i_contrib" =~ [^10] ]]
do
    :
done
if [[ $i_contrib == 0 ]]; then
  echo ""
  echo " Установка пакетов пропущена "
elif [[ $i_contrib == 1 ]]; then
  #echo ""
  #echo " Обновление баз данных пакетов, и системы через - AUR (Yay) "
  #yay -Syy
  #yay -Syu
  echo ""
  echo " Установка пакетов (pacman-contrib), (pcurses) "
  pacman -S --noconfirm --needed pacman-contrib  # Предоставленные скрипты и инструменты для систем pacman (https://github.com/kyrias/pacman-contrib)
### pacman -S --noconfirm --needed pcurses  # Инструмент управления пакетами curses с использованием libalpm ; pcurses позволяет просматривать пакеты и управлять ими во внешнем интерфейсе curses, написанном на C++ ; https://github.com/schuay/pcurses ; Раньше присутствовал в community ...
##### pcurses ######
### Зависимости ####
  pacman -S --noconfirm --needed ncurses  # Библиотека эмуляции проклятий System V Release 4.0 :https://archlinux.org/packages/core/x86_64/ncurses/
  pacman -S --noconfirm --needed pacman  # Менеджер пакетов на основе библиотеки с поддержкой зависимостей. https://archlinux.org/packages/core/x86_64/pacman/
  pacman -S --noconfirm --needed boost  # Бесплатные рецензируемые портативные исходные библиотеки C++ (заголовки для разработки). https://archlinux.org/packages/extra/x86_64/boost/ --! Помечен как устаревший 14 декабря 2023 г.
  pacman -S --noconfirm --needed cmake  # Кроссплатформенная система make с открытым исходным кодом. https://archlinux.org/packages/extra/x86_64/cmake/
  ##### pcurses ######
  git clone https://aur.archlinux.org/pcurses.git 
  cd pcurses
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# makepkg --noconfirm --needed -sic
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf mugshot
rm -Rf pcurses   # удаляем директорию сборки
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
# URL-адрес клона Git:  https://aur.archlinux.org/pcurses.git (только чтение, нажмите, чтобы скопировать)
# База пакета:  pcurses
# Описание: Инструмент управления пакетами проклятий с использованием libalpm.
# Восходящий URL-адрес: https://github.com/schuay/pcurses
# Лицензии: GPL2
# Отправитель:  arojas
# Сопровождающий: ralphptorres
# Последний упаковщик:  arojas
# Голоса: 8
# Популярность: 0,006875
# Впервые отправлено: 01.04.2022 18:11 (UTC)
# Последнее обновление: 01.04.2022 18:11 (UTC)

# <<< Делайте выводы сами! >>>

