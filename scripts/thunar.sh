#!/usr/bin/env bash
# Install script thunar
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
# wget git.io/thunar.sh && sh thunar.sh

echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git

clear
echo -e "${MAGENTA}
<<< Установка дополнительного программного обеспечения для исправления отображения миниатюр в файловом менеджере системы Archlinux >>> ${NC}"
# Installing additional software to fix thumbnail display in the Archlinux file Manager

echo ""
echo -e "${BLUE}:: ${NC}Исправим отображение миниатюр в файловом менеджере Thunar?"
# Fix Thumbnails in file manager
echo -e "${MAGENTA}=> ${BOLD}Thunar - обычно автоматически создает миниатюрные изображения всех изображений в просматриваемой директории. Но бывает, что в Arch Linux - Thunar иногда не показывает некоторые миниатюры. Все файлы изображений получают один и тот же общий значок изображения. ${NC}"
echo -e "${YELLOW}:: ${NC}Файловый менеджер thunar идет по умолчанию в графической оболочке xfce. Сам по себе thunar не содержит в себе лишних функций, которые могут запутать не опытного пользователя. Да и не всем нужен излишний функционал. Кастомизируется thunar очень легко, по этому у вас не должно возникнуть с этим проблем."
echo -e "${CYAN}:: ${NC}Нам - Потребуется доустановить дополнительные пакеты, и возможно надо включить показ миниатюр в настройках Thunar'а (или, может, в настройках Xfce)."
echo " Будьте внимательны! В любой ситуации выбор всегда остаётся за вами. "
# Be careful! In any situation, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да исправьте миниатюры в файловом менеджере,     0 - НЕТ - Пропустить действие: " set_fix  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$set_fix" =~ [^10] ]]
do
    :
done
if [[ $set_fix == 0 ]]; then
echo ""
echo " Действие исправления миниатюр в файловом менеджере пропущено "
elif [[ $set_fix == 1 ]]; then
  echo ""
  echo " Установка необходимого софта (пакетов) в систему "
#sudo pacman -S tumbler ffmpegthumbnailer poppler-glib libgsf libopenraw --noconfirm
sudo pacman -S tumbler --noconfirm  #  Сервис D-Bus для приложений, запрашивающих миниатюры
sudo pacman -S ffmpegthumbnailer --noconfirm  # Легкий эскиз видеофайлов, который может использоваться файловыми менеджерами
sudo pacman -S poppler-glib --noconfirm  # Наручники Poppler Glib
sudo pacman -S libgsf --noconfirm  # Расширяемая библиотека абстракции ввода-вывода для работы со структурированными форматами файлов
sudo pacman -S libopenraw --noconfirm  # Библиотека для декодирования файлов RAW
sudo pacman -S shared-mime-info --noconfirm  # Общая информация MIME на Freedesktop.org
sudo pacman -S raw-thumbnailer --noconfirm  # Легкий и быстрый инструмент для создания необработанных изображений raw, который необходим для отображения миниатюр raw.
sudo pacman -S perl-file-mimeinfo --noconfirm  # Определить тип файла, включая mimeopen и mimetype
############ gstreamer0.10 ##########
  #echo ""
  #echo " Обновление баз данных пакетов, и системы через - AUR (Yay) "
  #yay -Syy
  #yay -Syu
echo ""
echo " Установим мультимедийный фреймворк GStreamer из AUR "
#yay -S gstreamer0.10 --noconfirm  # Мультимедийный фреймворк GStreamer (Если установлен yay - эта команда)
git clone https://aur.archlinux.org/gstreamer0.10.git
cd gstreamer0.10
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf gstreamer0.10
rm -Rf gstreamer0.10
#######################
echo ""
echo " Создание пользовательских каталогов по умолчанию "
sudo pacman -S --noconfirm --needed xdg-user-dirs-gtk  # Создаёт каталоги пользователей и просит их переместить
#sudo pacman -S xdg-user-dirs-gtk --noconfirm  # Создаёт каталоги пользователей и просит их переместить
xdg-user-dirs-gtk-update  # Обновить закладки в thunar (левое меню)
echo ""
echo " Создание каталогов успешно выполнено "
echo ""
#mv ~/.cache/thumbnails ~/.cache/thumbnails.bak
# cp -R ~/.cache/thumbnails ~/.cache/thumbnails.bak
#echo " Удалим миниатюры фото, которые накапились в системе "
### thunar -q  # запустим менеджер thunar
### killall thunar  # завершим работу менеджера thunar
#sudo rm -rf ~/.cache/thumbnails/  # удаляет миниатюры фото, которые накапливаются в системе
#sudo rm -rf ~/.cache/thumbnails/*
echo " Создадим backup папки /.config/Thunar "
sudo mv ~/.config/Thunar ~/.config/Thunar.bak
# mv ~/.config/Thunar ~/.config/Thunar.bak
echo " Выполним резервное копирование каталога /usr/share/mime, на всякий случай "
sudo cp -R /usr/share/mime /usr/share/mime_back
#cp -R /usr/share/mime /usr/share/mime_back
#echo " Удалить все файлы .xml на /usr/share/mime, затем запустим команду обновления "
#find  /usr/share/mime -name *.xml -exec rm -rfv {} +  #
echo " Обновление общего кэша информации mime в соответствии с системой "
sudo update-mime-database /usr/share/mime
echo " Желательно ПОСЛЕ этих действий выйдите из системы и снова войдите в систему, или перезагрузитесь "  # Then logout and back in or Reboot
echo " Но, мы просто перезапустим файловый менеджер Thunar "
thunar -q # запустим менеджер thunar
echo ""
echo " Проверяем дефолтные настройки миниатюр (xdg-mime query default) "
xdg-mime query default inode/directory
echo " Переопределяем на файловый менеджер Thunar "
xdg-mime default thunar.desktop inode/directory
# Чтобы открыть каталог и выбрать подкаталог / файл в thunar:
# thunar --select path/to/file/or/directory
### xdg-mime default org.gnome.Nautilus.desktop inode/directory  # или Nautilus
# Чтобы открыть каталог и выбрать подкаталог / файл в наутилусе:
### nautilus --select path/to/file/or/directory
echo " Расширяем контекстное меню Thunar (Добавляем дополнительные пункты для создания файлов) "
echo " Создание шаблонов файлов в ~/Templaytes (чтобы в контекстном меню отображался пункт New Document) "
XDG_TEMPLATES_DIR=$(xdg-user-dir TEMPLATES)
cd "$XDG_TEMPLATES_DIR"
touch 'New Text File.txt' && touch 'New Word File.doc' && touch 'New Excel Spreadsheet.xls'
touch 'New HTML File.html' && touch 'New XML File.xml' && touch 'New PHP Source File.php'
touch 'New File Block Diagram.odg' && touch 'New Casscading Style Sheet.css' && touch 'New Java Source File.java'
touch 'New ODB DataBase.odb' && touch 'New ODT File.odt' && touch 'New Table ODS.ods' && touch 'New File Excel.et'
touch 'New File DPS Presentation.dps' && touch 'New File ODP Presentation.odp' && touch 'New File PowerPoint Presentation.ppt'
touch 'New File README.md' && touch 'New Pyfile.py'
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
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

# touch ~/Templates/{Empty\ Document,Text\ Document.txt,README.md,pyfile.py}
# ---------------------------------
# Затем, выставить в настройках Thunar галочку, предписывающую показывать миниатюры, если это возможно!
# Почистить cache:
# /home/user/.thumbnails
# /home/user/.cache/Thunar
# update-mime-database  # программа для построения кэша Shared MIME-Info базы данных
# Это программа, которая отвечает за обновление общего кэша информации mime в соответствии с системой, описанной в спецификации Shared MIME-Info Database от X Desktop Group
#/usr/share/mime  # файл конфигурации MIME-типов
# ----------------------------
# https://wiki.archlinux.org/index.php/Thunar_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# https://www.opennet.ru/man.shtml?topic=update-mime-database&category=1&russian=2
# https://unix.stackexchange.com/questions/364997/open-a-directory-in-the-default-file-manager-and-select-a-file
# https://specifications.freedesktop.org/mime-apps-spec/mime-apps-spec-1.0.1.html
# ----------------------------------
# Запросы
# xdg-mime query filetype <filename> позволяет узнать mime-тип файла.
# xdg-mime query default <mime-type> – узнать приложение по умолчанию для открытия данного mime-типа.
# Установка умолчаний
# xdg-mime default <desktop-file-name> <mime-type>... позволяет установить приложение <desktop-file-name> по умолчанию для открытия одного или нескольких mime-типов. <desktop-file-name> – это название desktop-файла, который будет использован (без пути, с расширением)
# Например:
# xdg-mime default okular.desktop image/jpeg image/png
# В случае, если возможно установить окружение рабочего стола, для этого будут использованы средства окружения. Иначе, будут добавлены записи в файл mimeapps.list (первый найденный) в секцию Default Applications.
# РЕКОМЕНДАЦИИ
# Всегда устанавливайте переменную BROWSER. Если она не установлена, можно ждать неожиданностей. Можно указывать список, разделённый двоеточием :.
# Используйте xdg-mime default для установки приложений по умолчанию. Если требуется посмотреть список умолчаний, можно посмотреть в файл mimeapps.list, однако редактировать его напрямую в общем случае не рекомендуется.
# https://wiki.archlinux.org/index.php/Default_applications_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# Общая база данных MIME-информации
# https://specifications.freedesktop.org/shared-mime-info-spec/shared-mime-info-spec-0.11.html#idm139839923550176
# Небольшая заметка про xdg-open
# https://livid.pp.ru/posts/2016-03-08-xdg-open.html
# ----------------------------
# Ассоциации файлов
# Это нужно, если у вас открывается файл, или каталог не в той программе. Например, директория в музыкальном проигрывателе.
# Распознаем файл:
### xdg-mime query filetype wallpaper.jpg  # определение типа MIME файла
### xdg-mime query filetype photo.jpeg  # определение типа MIME файла
# Определение приложения по умолчанию для типа MIME:
### xdg-mime query default image/jpeg
# Изменение приложения по умолчанию для типа MIME
### xdg-mime default feh.desktop image/jpeg
# Открытие файла со своим стандартным приложением:
### xdg-open photo.jpeg
# Ярлык для открытия всех веб типов MIME с помощью одного приложения
### xdg-settings set default-web-browser firefox.desktop
# Ярлык для установки приложения по умолчанию для схемы URL
### xdg-settings set default-url-scheme-handler irc xchat.desktop
# Еще пример:
### xdg-mime default vlc.desktop video/mp4
# Нестандартная ассоциация:
# Приложения могут игнорировать или частично реализовывать стандарт XDG. Проверьте использование устаревших файлов, таких как ~/.local/share/applications/mimeapps.list и ~/.local/share/applications/defaults.list. Если вы пытаетесь открыть файл из другого приложения (например, веб-браузера или файлового менеджера), проверьте, имеет ли это приложение собственный способ выбора приложений по умолчанию.
# База данных MIME
# Система поддерживает базу данных распознанных типов MIME: Общая база данных MIME. База данных построена из файлов XML, установленных пакетами в /usr/share/mime/packages, используя инструменты из shared-mime-info.
# Файлы в /usr/share/mime/ не должны редактироваться напрямую, однако их можно сохранить в отдельную базу данных для каждого пользователя в ~/.local/share/mime/.
# Default applications (Русский)
# https://wiki.archlinux.org/index.php/Default_applications_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)

# -------------------------------------------------

# Если в системе не установлены необходимые зависимости, makepkg предупредит вас об этом и отменит сборку. Если задать флаг -s/--syncdeps, то makepkg самостоятельно установит недостающие зависимости и соберёт пакет.
# $ makepkg --syncdeps

# ---------------------------------------------------
# URL-адрес клона Git: https://aur.archlinux.org/gstreamer0.10.git (только чтение, нажмите, чтобы скопировать)
# База пакета:  gstreamer0.10
# Описание: Мультимедийная платформа GStreamer
# Восходящий URL-адрес: https://gstreamer.freedesktop.org
# Лицензии: LGPL
# Отправитель:  yurikoles
# Сопровождающий: ava1ar
# Последний упаковщик:  Matr1x-101
# Голоса: 125
# Популярность: 0.55
# Впервые отправлено: 2017-01-26 13:42 (UTC)
# Последнее обновление: 2022-05-20 18:22 (UTC)
# --------------------------------------#

# <<< Делайте выводы сами! >>>

