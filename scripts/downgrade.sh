#!/usr/bin/env bash
# Install script downgrade
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
# wget git.io/downgrade.sh && sh downgrade.sh

echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Downgrading packages"
#echo -e "${BLUE}:: ${NC}Установить Downgrading packages "
#echo 'Установить Downgrading packages '
# To install Downgrading packages
echo " Ставим пакет (downgrade) - Bash-скрипт для понижения версии одного или нескольких пакетов до версии в вашем кэше или ALA. "
echo -e "${YELLOW}==> Примечание: ${NC}Откат версии пакета НЕ рекомендуется и применяется в том случае, когда в текущем пакете обнаружена ошибка."
echo -e "${MAGENTA}:: ${NC}Прежде чем откатить пакет, подумайте, нужно ли это делать. Если необходимость отката вызвана ошибками, пожалуйста, помогите сообществу Arch и разработчикам этого ПО, потратьте несколько минут на составление отчета об ошибке и отправке его в трекер ошибок Arch или на сайт самого проекта. В связи с безрелизной моделью развития Arch при продолжительном его использовании, Вы, возможно, периодически будете сталкиваться с ошибками в новых пакетах. Наше сообщество и разработчики ПО будут признательны Вам за приложенные усилия. Дополнительная информация может не только спасти нас от часов тестирования и отладки, но также позволит повысить стабильность программного обеспечения. "
echo -e "${CYAN}:: ${NC}Установка Downgrading (downgrade) проходит через сборку из исходников. То есть установка производиться с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/downgrade/) - собирается и устанавливается. "
# https://wiki.archlinux.org/index.php/Downgrading_packages_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. В данной опции выбор остаётся за вами. "
# Be careful! The installation process was fully automatic. In this option, the choice is yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да установить, 0 - НЕТ - Пропустить установку: " downgrade_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " downgrade_set  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$downgrade_set" =~ [^10] ]]
do
    :
done
if [[ $downgrade_set == 0 ]]; then
# clear
  echo ""
  echo " Bash-скрипт для понижения версии одного или нескольких пакетов (downgrade) пропущена "
elif [[ $downgrade_set == 1 ]]; then
  #echo ""
  #echo " Обновление баз данных пакетов, и системы через - AUR (Yay) "
  #yay -Syy
  #yay -Syu
  echo ""
  echo " Установка downgrade - Bash-скрипт для понижения версии пакетов"
  git clone https://aur.archlinux.org/downgrade.git  # Bash-скрипт для понижения версии пакетов
  cd downgrade
#makepkg -fsri
# makepkg -si
  makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
  pwd    # покажет в какой директории мы находимся
  cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf downgrade
  rm -Rf downgrade
# clear
  echo ""
  echo " Bash-скрипт (downgrade) успешно установлен! "
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

