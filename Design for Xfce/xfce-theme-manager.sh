#!/usr/bin/env bash
# Install script xfce-theme-manager
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
# wget git.io/xfce-theme-manager.sh && sh xfce-theme-manager.sh

echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git

#clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Xfce-Theme-Manager (xfce-theme-manager) — Интегрированный менеджер тем для xfce4?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *ПОЖАЛУЙСТА, ОБРАТИ ВНИМАНИЕ!!! Этот проект сейчас находится в режиме поддержки. Автор НЕ принимает никаких предложений по новым функциям. Будет ТОЛЬКО принимать и исправлять ошибки. См. файл readme, страницу руководства или веб-страницу: (https://keithdhedger.github.io/pages/apps.html#themeed). Для тех кто ранее использовал Gnome, может не понравится то что в диалоге настроек стилей и значков отсутствуют эскизы тем... Исправить эту ситуацию поможет простой Python / GTK (gtkdialog) скрипт Xfce-Theme-Manager. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Xfce-Theme-Manager — В Xfce используется оконный менеджер Xfwm, который включает в себя собственный композитный менеджер (с версии 4.2), с интересными эффектами окон, тенью, прозрачностью и прочим... Поддержка композитности может быть включена в дополнительных настройках "Диспетчера окон", в вкладке "Эффекты" (функция требует аппаратной поддержки графики). Для доступа к более тонким настройкам композитного менеджера, которые отсутствуют в официальном интерфейсе, можно воспользоваться простым Python / GTK (gtkdialog) скриптом Xfce4-Composite-Editor. Xfce4-Composite-Editor имеет простой интерфейс, поможет легко настроить прозрачность для оформления активных и неактивных окон, прозрачность окон во время их перемещении и изменении размера, прозрачность для всплывающих окон и панели (некоторые настройки требуют перезапуска оконного менеджера). Этот проект Лицензируется под GPL-3.0 или более поздняя версия. ${NC}"
echo " Домашняя страница: https://github.com/KeithDHedger/Xfce-Theme-Manager ; (https://aur.archlinux.org/packages/xfce-theme-manager ; https://aur.archlinux.org/packages/xfce4-composite-editor). "
echo -e "${BLUE}:: ${NC}Функции: Для использования скрипта, нужно положить (скопировать) его в каталог: '/usr/local/bin' . Для того что бы запускать его из меню Xfce, файл Xfce-Theme-Manager.desktop (находящийся в архиве с скриптом) нужно положить (скопировать) в каталог: '/usr/local/share/applications или в ~/.local/share/applications'. "
echo -e "${CYAN}:: ${NC}Xfce является универсальной, стабильной, простой и легковесной средой рабочего стола. Разрабатывается окружение что бы быть производительной, быстро загружать и выполнять приложения, сохраняя системные ресурсы. Xfce это прекрасный пример того, как полнофункциональная среда рабочего стола, имеющая богатые возможности, одновременно с этим остаётся легковесной. Конфигурация и работа со средой может полностью выполняться мышью, без необходимости правки конфигурационных файлов. Все основные настройки Xfce собраны в один интерфейс, "Диспетчер настроек / Менеджер настроек Xfce", с помощью которого доступно большинство настроек окружения. Количество настроек и их интуитивное расположение позволяет пользователю легко настроить его по своему вкусу и потребностям. "
echo -e "${CYAN}:: ${NC}Установка Xfce-Theme-Manager (xfce-theme-manager) и (xfce4-composite-editor), проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/xfce-theme-manager.git), (https://aur.archlinux.org/xfce4-composite-editor.git) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_composite  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_composite" =~ [^10] ]]
do
    :
done
if [[ $in_composite == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_composite == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Xfce-Theme-Manager (xfce-theme-manager) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
######## xfce-theme-manager ##############
yay -S xfce-theme-manager --noconfirm  # Интегрированный менеджер тем для xfce4 ; https://aur.archlinux.org/packages/xfce-theme-manager ; https://aur.archlinux.org/xfce-theme-manager.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/KeithDHedger/Xfce-Theme-Manager ; https://github.com/KeithDHedger/Xfce-Theme-Manager/archive/v0.3.9.tar.gz ; 2025-05-27 10:06 (UTC)
######## xfce-theme-manager ##############
#git clone https://aur.archlinux.org/xfce-theme-manager.git  # (только для чтения, нажмите, чтобы скопировать)
#cd xfce-theme-manager
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf xfce-theme-manager
#rm -Rf xfce-theme-manager
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
######## xfce4-composite-editor ##############
yay -S xfce4-composite-editor --noconfirm  # (необязательно) – простой графический интерфейс для настройки xfwm, может быть запущен из xfce-theme-manager ; https://aur.archlinux.org/packages/xfce4-composite-editor ; https://aur.archlinux.org/xfce4-composite-editor.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/KeithDHedger/Xfwm4CompositeEditor ; https://github.com/KeithDHedger/Xfwm4CompositeEditor/archive/xfce4-composite-editor-0.2.2.tar.gz ; 2021-01-17 01:40 (UTC)
######## xfce4-composite-editor ##############
#git clone https://aur.archlinux.org/xfce4-composite-editor.git  # (только для чтения, нажмите, чтобы скопировать)
#cd xfce4-composite-editor
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf xfce4-composite-editor
#rm -Rf xfce4-composite-editor
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##############
### Для использования скрипта, нужно положить (скопировать) его в каталог: /usr/local/bin
# Для того что бы запускать его из меню Xfce,
# файл Xfce-Theme-Manager.desktop (находящийся в архиве с скриптом) нужно положить (скопировать) в каталог:
# /usr/local/share/applications или в ~/.local/share/applications
#############################
clear

# Успех
#Success
echo "Установка завершена! Перезагрузить."
#echo "Installation complete! Reboot."

# <<< Делайте выводы сами! >>>
#
