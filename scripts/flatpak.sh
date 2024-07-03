#!/usr/bin/env bash
# Install script flatpak
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
# wget git.io/flatpak.sh && sh flatpak.sh

echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Flatpak (инструмент для управления приложениями) на Arch Linux?"
#echo -e "${BLUE}:: ${NC}Установить Snap на Arch Linux?"
#echo 'Установить Snap на Arch Linux?'
# To install Snap-on Arch Linux?
echo -e "${MAGENTA}:: ${BOLD}Flatpak - это система для создания, распространения и запуска изолированных настольных приложений в Linux. Основной репозиторий flatpak flathub.org/apps. ${NC}"
echo -e "${CYAN}:: ${NC}Flatpak - это инструмент для управления приложениями и средами выполнения, которые они используют. В модели Flatpak приложения можно создавать и распространять независимо от хост-системы, в которой они используются, и они в некоторой степени изолированы от хост-системы («изолированы») во время выполнения.
Flatpak использует OSTree для распространения и развертывания данных."
echo -e "${CYAN}:: ${NC}Репозитории, которые он использует, являются репозиториями OSTree, и ими можно управлять с помощью утилиты ostree. Установленные среды выполнения и приложения являются проверками OSTree."
echo -e "${YELLOW}==> Примечание: ${NC}Если вы хотите создавать пакеты с плоскими пакетами, flatpak-builderвам необходимо установить дополнительные зависимости elfutils и patch."
echo " Приложение Flaptpak создается и запускается в изолированной среде, известной как 'песочница'. "
echo " Один из способов управления вашими Флэтпаками-это приложение Discover из проекта KDE. Вы можете установить пакет discover с помощью вашего менеджера пакетов. "
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
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_sandbox  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_sandbox" =~ [^10] ]]
do
    :
done
if [[ $i_sandbox == 0 ]]; then
echo ""
echo " Установка инструмента Flatpak пропущена "
elif [[ $i_sandbox == 1 ]]; then
###### Flatpak ##############	
  echo ""
  echo " Установка Flatpak (инструмента для управления приложениями и средами выполнения) "
sudo pacman -S flatpak --noconfirm  # Среда изолированной программной среды и распространения приложений Linux (ранее xdg-app)
sudo pacman -S elfutils patch --noconfirm  # Утилиты для обработки объектных файлов ELF и отладочной информации DWARF, и Утилита для применения патчей к оригинальным источникам
#echo ""
#echo " Добавление репозитория flathub "
#flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
# Удаление репозитория на примере flathub:
# flatpak remote-delete flathub
# flatpak update  # Обновление flatpak
clear
echo ""
echo " Установка приложение Flatpak выполнена "
echo ""
echo -e "${BLUE}:: ${NC}Установить приложение для управления вашими Flatpaks (флэтпаками)?"
echo " Discover - Один из способов управления вашими Флэтпаками, есть ещё Gnome Software из проекта 'Gnome Project'. "
echo " Меннеджер пакетов Gnome Software, хорошо использовать в связке с flatpak. "
echo " Gnome Software - ПОДТЯГИВАЕТ МНОГО ЗАВИСИМОСТЕЙ! "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить Discover (из проекта KDE),     2 - Установить Gnome Software (из Gnome Project),

    0 - НЕТ - Пропустить установку: " i_discover  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_discover" =~ [^120] ]]
do
    :
done
if [[ $i_discover == 0 ]]; then
echo ""
echo " Установка приложения для управления вашими Flatpaks пропущена "
elif [[ $i_discover == 1 ]]; then
  echo ""
  echo " Установка Discover (для управления вашими Flatpaks) "
sudo pacman -S discover --noconfirm  # Графический интерфейс управления ресурсами KDE и Plasma
echo ""
echo " Установка приложение Discover (из проекта KDE) выполнена "
elif [[ $i_discover == 2 ]]; then
  echo ""
  echo " Установка Gnome Software (для управления вашими Flatpaks) "
sudo pacman -S gnome-software --noconfirm  # Программные инструменты GNOME - ПОДТЯГИВАЕТ МНОГО ЗАВИСИМОСТЕЙ!
sudo pacman -S gnome-software-packagekit-plugin --noconfirm  # Плагин поддержки PackageKit для программного обеспечения GNOME
echo ""
echo " Установка приложение Gnome Software (из Gnome Project) выполнена "
fi
fi
# -------------------------------------
# Отобразить список всех плоских пакетов и сред выполнения, установленных в данный момент:
# flatpak list
# Обновление вашей коллекции Flatpak:
# flatpak upgrade
# Если вы не хотите устанавливать приложения в масштабе системы, вы также можете устанавливать приложения flatpak для каждого пользователя отдельно, как показано ниже.
# flatpak install --user <имя_приложения>
# В данном случае все установленные приложения будут храниться в $HOME/.var/app/location.
# ls $HOME/.var/app/
# com.spotify.Client
# Запуск приложений Flatpak
# Вы можете запускать установленное приложение в любое время из панели запуска приложений. Из командной строки вы можете запустить его, например Spotify, используя команду:
# flatpak run com.spotify.Client
# Найдем приложения Flatpak. Для поиска приложения:
# flatpak search gimp
# Чтобы вывести список всех настроенных удаленных репозиториев, запустите:
# flatpak remotes
# -------------------------------------
# Flatpak:
# https://wiki.archlinux.org/index.php/Flatpak
# Flatpak Manjaro:
# https://wiki.manjaro.org/index.php?title=Flatpak
# --------------------------------------
# Основной репозиторий flatpak flathub.org/apps.
# Добавление репозитория на примере flathub:
# flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
# Удаление репозитория на примере flathub:
#flatpak remote-delete flathub
# Обновление flatpak:
# flatpak update
# Поиск:
# flatpak search libreoffice
# Список пакетов в репозитории flathub:
# flatpak remote-ls flathub
# Установка пакета в домашнюю дерикторию.
# flatpak install flathub com.valvesoftware.Steam
# Запуск:
# flatpak run com.valvesoftware.Steam
# Список установленых пакетов:
# flatpak list
# Обновление пакета:
# flatpak update com.valvesoftware.Steam
# Обновление пакетов:
# flatpak update
# Удаление пакета:
# flatpak uninstall com.valvesoftware.Steam
# После удаления приложения могут оставаться неиспользуемые рантаймы, очистим и их.
# flatpak uninstall --unused
# Дополнительный репозиторий Winepak (игры, WoT и др.).
# https://winepak.org.
# https://github.com/winepak/applications.
# ------------------------------
# Показанные инструкции могут не работать:
# flatpak remote-add flathub https://flathub.org/repo/flathub.flatpakrepo
# flatpak --user install flathub org.gnome.Recipes
# если выдает ошибку "удаленный flathub не найден"
# вместо этого вам нужно либо установить пульт с --user, либо установить приложение flatpak без --user
#Просто:
# flatpak install flathub org.gnome.Recipes
# запустите flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepoв терминале, и все должно работать, что позволит вам установить fltpaks из flathub
# Вы можете сделать это вручную с помощью:
# remote-add --user
# sudo flatpak удаленно удалить flathub
# sudo flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# https://www.flathub.org/home
# =============================
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

