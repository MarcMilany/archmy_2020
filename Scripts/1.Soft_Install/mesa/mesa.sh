#!/usr/bin/env bash
# Install script mesa
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url

echo ""
echo " Установка необходимого софта (пакетов) в систему "
sudo pacman -Syy  # обновление баз пакмэна (pacman)   
####################### Mesa ######################
### sudo pacman -S --noconfirm --needed mesa-amber  # классические драйверы OpenGL (не Gallium3D) ; https://www.mesa3d.org/ ; https://archlinux.org/packages/extra/x86_64/mesa-amber/
### ошибка: обнаружен неразрешимый конфликт пакетов
### ошибка: не удалось подготовить транзакцию (конфликтующие зависимости)
### :: mesa-amber-21.3.9-6 and mesa-1:24.1.3-1 are in conflict
### sudo pacman -S --noconfirm --needed lib32-mesa-amber  # классические драйверы OpenGL (не Gallium3D) (32-бит) ; https://www.mesa3d.org/ ; https://archlinux.org/packages/multilib/x86_64/lib32-mesa-amber/
### ошибка: обнаружен неразрешимый конфликт пакетов
### ошибка: не удалось подготовить транзакцию (конфликтующие зависимости)
### :: lib32-mesa-amber-21.3.9-6 and lib32-mesa-1:24.1.3-1 are in conflict
sudo pacman -S --noconfirm --needed mesa-utils  # Основные коммунальные услуги Месы ; https://www.mesa3d.org/ ; https://archlinux.org/packages/extra/x86_64/mesa-utils/
sudo pacman -S --noconfirm --needed lib32-mesa-utils  # Основные утилиты Mesa (32-бит) ; http://mesa3d.sourceforge.net/ ; https://archlinux.org/packages/multilib/x86_64/lib32-mesa-utils/
# sudo pacman -S --noconfirm --needed

#Success
echo "Установка завершена! Перезагрузить."
#echo "Installation complete! Reboot."

# <<< Делайте выводы сами! >>>