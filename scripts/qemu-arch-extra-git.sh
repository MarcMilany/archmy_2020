#!/usr/bin/env bash
# Install script qemu-arch-extra-git
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
# wget git.io/qemu-arch-extra-git.sh && sh qemu-arch-extra-git.sh

echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить QEMU для зарубежных архитектур?"
echo -e "${MAGENTA}:: ${BOLD}QEMU-git - это универсальный эмулятор машины, основанный на динамической трансляции, который может работать в двух разных режимах. ${NC}"
echo " Полная эмуляция системы: режим, полностью имитирующий компьютер. Его можно использовать для запуска различных операционных систем (ОС). Эмуляция пользовательского режима: позволяет запускать процесс для одного типа ЦП на другом ЦП. "
echo -e "${YELLOW}==> Примечание! ${NC}Если у вас есть x86 машина, вы можете использовать QEMU с KVM и добиться высокой производительности."
echo " Имейте в виду, что нам следует избегать работы внутри виртуальной машины, поскольку это пустая трата вычислительных ресурсов. Мы хотим максимально работать внутри хоста и использовать ВМ только для тестирования; В связи с этим и для создания комфортной рабочей среды нам необходимо: SSH-доступ; для совместного использования каталога хостом и гостем. "
echo -e "${CYAN}:: ${NC}Установка QEMU (qemu-git) ; (qemu-arch-extra-git) проходит через сборку из исходников. То есть установка производиться с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/qemu-arch-extra-git) - собирается и устанавливается. "
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
# Be careful! The installation process, after the option you selected, was registered fully automatic. In this option, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_qemu  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_qemu" =~ [^10] ]]
do
    :
done
if [[ $i_qemu == 0 ]]; then
echo ""
echo " Установка QEMU Git пропущена "
elif [[ $i_qemu == 1 ]]; then
  #echo ""
  #echo " Обновление баз данных пакетов, и системы через - AUR (Yay) "
  #yay -Syy
  #yay -Syu
  echo ""
  echo " Установка QEMU Git (qemu-git) "  
#### qemu-git #######
#yay -S qemu-git --noconfirm  # QEMU для зарубежных архитектур,Версия QEMU Git.
git clone https://aur.archlinux.org/qemu-git.git 
cd qemu-git
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf qemu-git
rm -Rf qemu-git
# rm -Rf qemu-git
echo ""
echo " Установка утилит (пакетов) выполнена "
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
# URL-адрес клона Git:  https://aur.archlinux.org/qemu-git.git (только чтение, нажмите, чтобы скопировать)
# База пакета:  qemu-git
# Описание: Версия QEMU Git.
# Восходящий URL-адрес: https://wiki.qemu.org/
# Лицензии: GPL2, LGPL2.1
# Конфликты:  qemu-arch-extra, qemu-emulators-full
# Отправитель:  None
# Сопровождающий: FredBezies
# Последний упаковщик:  FredBezies
# Голоса: 29
# Популярность: 0.000156
# Впервые отправлено: 2009-09-19 20:02 (UTC)
# Последнее обновление: 2024-06-19 11:41 (UTC)
# ---------------------------------------------------
# <<< Делайте выводы сами! >>>
#
