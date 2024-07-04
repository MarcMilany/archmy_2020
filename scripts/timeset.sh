#!/usr/bin/env bash
# Install script timeset
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
# wget git.io/timeset.sh && sh timeset.sh

echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git

clear
echo -e "${MAGENTA}
  <<< Установить дополнительных утилит для Синхронизации времени (Если Вы обнаружите, что время сбиваться по различным причинам). >>> ${NC}"

echo ""
echo -e "${GREEN}==> ${NC}Установить TimeSet (bash скрипт - timeset) и GUI интерфейс для управления системной датой и временем (timeset-gui) из AUR"
#echo 'Установить TimeSet (bash скрипт - timeset) и GUI интерфейс для управления системной датой и временем (timeset-gui)
# Install TimeSet and GUI...
echo -e "${BLUE}:: ${BOLD}Посмотрим дату, время, и часовой пояс ... ${NC}"
timedatectl | grep "Time zone"
date
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'     # одновременно отображает дату и часовой пояс
echo ""
echo -e "${YELLOW}=> ${NC}Если при двойной загрузке с Windows или любой другой ОС Вы обнаружите, что время сбиваться, это может быть связано с тем, что они используют разные значения времени для аппаратных часов. Arch (& Manjaro) считает, что аппаратные часы находятся в формате UTC, в то время как Windows и некоторые другие дистрибутивы Linux предполагают, что аппаратные часы находятся в местном времени. Чтобы исправить это, можно настроить Windows на использование аппаратного времени в формате UTC."
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют следующие варианты: ${NC}"
echo " 1 - TimeSet (bash скрипт - timeset) - пакет (timeset - Скрипт для управления системной датой и временем) "
echo -e "${CYAN}:: ${NC}Установка TimeSet (timeset) проходит через сборку из исходников. То есть установка производиться с помощью git clone (https://aur.archlinux.org/timeset.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux - AUR' (https://aur.archlinux.org/packages/timeset/) - собирается и устанавливается. "
echo " 2 - TimeSet-GUI (python скрипт - timeset-gui) - пакет (timeset-gui - Графический интерфейс для управления системной датой и временем) "
echo -e "${CYAN}:: ${NC}Установка TimeSet-GUI (timeset-gui) проходит через сборку из исходников. То есть установка производиться с помощью git clone (https://aur.archlinux.org/timeset-gui.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux - AUR' (https://aur.archlinux.org/packages/timeset-gui/) - собирается и устанавливается. "
echo -e "${YELLOW}==> Внимание! ${NC}Для полноценной установки у Вас должен быть установлен NTP (Network Time Protocol) - (пакет ntp), и Gksu (Графический интерфейс для su) - (пакет gksu), которые являются зависимостями для установки."
echo -e "${CYAN}:: ${NC}Возможно эти зависимости были установлены вами ранее!"  # NTP Servers (серверы точного времени) - https://www.ntp-servers.net/; Introduction - https://www.ntppool.org/ru/
echo " Будьте внимательны! В данной опции выбор всегда остаётся за вами. "
echo -e "${CYAN}==> ${NC}Рекомендую выбрать вариант "1" (Установим СРАЗУ timeset и timeset-gui)"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить TimeSet и TimeSet-GUI (timeset; timeset-gui),     2 - Установить TimeSet (bash скрипт - timeset)

    0 - НЕТ - Пропустить установку: " i_timeset  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_timeset" =~ [^120] ]]
do
    :
done
if [[ $i_timeset == 0 ]]; then
echo ""
echo " Установка пропущена "
elif [[ $i_timeset == 1 ]]; then
  #echo ""
  #echo " Обновление баз данных пакетов, и системы через - AUR (Yay) "
  #yay -Syy
  #yay -Syu
  echo ""
  echo " Установка TimeSet и TimeSet-GUI (графический интерфейс для управления системной датой) "
# yay -S timeset --noconfirm  # Скрипт для управления системной датой и временем
# yay -S timeset-gui --noconfirm  # Графический интерфейс для управления системной датой
echo " Установка TimeSet (пакета - timeset) "
##### timeset ######
git clone https://aur.archlinux.org/timeset.git
cd timeset
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf timeset
rm -Rf timeset   # удаляем директорию сборки
echo " Установка TimeSet-GUI (пакета - timeset-gui) "
##### timeset-gui ######
git clone https://aur.archlinux.org/timeset-gui.git
cd timeset-gui
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf timeset-gui
rm -Rf timeset-gui   # удаляем директорию сборки
echo ""
echo " Установка TimeSet и TimeSet-GUI (timeset; timeset-gui) выполнена "
echo " Время точное как на Спасской башне Московского Кремля! "
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'   # одновременно отображает дату и часовой пояс
elif [[ $i_timeset == 2 ]]; then
  #echo ""
  #echo " Обновление баз данных пакетов, и системы через - AUR (Yay) "
  #yay -Syy
  #yay -Syu  
  echo ""
  echo " Установка TimeSet (скрипт для управления системной датой и временем) "
# yay -S timeset --noconfirm  # Скрипт для управления системной датой и временем
##### timeset ######
git clone https://aur.archlinux.org/timeset.git
cd timeset
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf timeset
rm -Rf timeset   # удаляем директорию сборки
echo ""
echo " Установка TimeSet (timeset) выполнена "
echo " Время точное как на Спасской башне Московского Кремля! "
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'   # одновременно отображает дату и часовой пояс
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
# URL-адрес клона Git: https://aur.archlinux.org/timeset.git (только чтение, нажмите, чтобы скопировать)
# База пакета:  timeset
# Описание: Скрипт для управления системной датой и временем.
# Восходящий URL-адрес: https://github.com/aadityabagga/timeset
# Лицензии: GPL
# Отправитель:  aaditya
# Сопровождающий: aaditya
# Последний упаковщик:  aaditya
# Голоса: 4
# Популярность: 0.000000
# Впервые отправлено: 2013-11-04 12:34 (UTC)
# Последнее обновление: 2018-10-02 12:09 (UTC)
# --------------------------------------#
# URL-адрес клона Git: https://aur.archlinux.org/timeset-gui.git  (только чтение, нажмите, чтобы скопировать)
# База пакета:  timeset-gui
# Описание: Графический интерфейс для управления системной датой и временем.
# Восходящий URL-адрес: https://github.com/aadityabagga/timeset-gui
# Лицензии: GPL
# Отправитель:  aaditya
# Сопровождающий: aaditya
# Последний упаковщик:  aaditya
# Голоса: 8
# Популярность: 0.000000
# Впервые отправлено: 2013-11-20 12:32 (UTC)
# Последнее обновление: 2022-06-01 12:43 (UTC)
# --------------------------------------#

# <<< Делайте выводы сами! >>>

