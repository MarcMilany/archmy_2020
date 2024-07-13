#!/usr/bin/env bash
# Install script github
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
# wget git.io/git-hub.sh && sh git-hub.sh

echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git  # Сетевая утилита для извлечения файлов из Интернета, Быстрая распределенная система контроля версий, Инструмент командной строки и библиотека для передачи данных с помощью URL-адресов.

echo""
echo " Установка DeaDBeeF (как и 0xDEADBEEF ) — это модульный кроссплатформенный аудиоплеер, работающий в дистрибутивах GNU/Linux, macOS, Windows, *BSD, OpenSolaris и других UNIX-подобных системах...) "
echo " DeaDBeeF воспроизводит множество аудиоформатов, конвертирует их между собой, позволяет настраивать пользовательский интерфейс практически любым удобным для вас способом и использовать множество дополнительных плагинов , которые могут еще больше его расширить. "
############ Зависимости ################
# sudo pacman -R 
# sudo pacman -R  --noconfirm 
###  --noconfirm   не спрашивать каких-либо подтверждений
### Недостающие зависимости ####
# sudo pacman -S --noconfirm --needed curl  # Инструмент командной строки и библиотека для передачи данных с помощью URL-адресов. https://archlinux.org/packages/core/x86_64/curl/
# sudo pacman -S --noconfirm --needed git  # Быстрая распределенная система контроля версий. https://archlinux.org/packages/extra/x86_64/git/
sudo pacman -S --noconfirm --needed alsa-lib  # Альтернативная реализация поддержки звука в Linux. https://archlinux.org/packages/extra/x86_64/alsa-lib/
sudo pacman -S --noconfirm --needed gtk3  # Мультиплатформенный набор инструментов графического интерфейса на основе GObject. https://archlinux.org/packages/extra/x86_64/gtk3/
sudo pacman -S --noconfirm --needed jansson  # Библиотека C для кодирования, декодирования и управления данными JSON. https://archlinux.org/packages/core/x86_64/jansson/
sudo pacman -S --noconfirm --needed libdispatch  # Комплексная поддержка одновременного выполнения кода на многоядерном оборудовании. https://archlinux.org/packages/extra/x86_64/libdispatch/
sudo pacman -S --noconfirm --needed clang  # Интерфейс семейства языков C для LLVM. (Помечено как устаревшее 07.03.2024) https://archlinux.org/packages/extra/x86_64/clang/
sudo pacman -S --noconfirm --needed faad2  # Бесплатный расширенный аудиодекодер (AAC). https://archlinux.org/packages/extra/x86_64/faad2/
sudo pacman -S --noconfirm --needed ffmpeg  # Комплексное решение для записи, преобразования и потоковой передачи аудио и видео. https://archlinux.org/packages/extra/x86_64/ffmpeg/
sudo pacman -S --noconfirm --needed flac  # Бесплатный аудиокодек без потерь. https://archlinux.org/packages/extra/x86_64/flac/
sudo pacman -S --noconfirm --needed imlib2  # Библиотека, которая выполняет загрузку и сохранение файлов изображений, а также рендеринг, манипулирование и поддержку произвольных многоугольников. https://archlinux.org/packages/extra/x86_64/imlib2/
sudo pacman -S --noconfirm --needed intltool  # Коллекция инструментов интернационализации. https://archlinux.org/packages/extra/any/intltool/
sudo pacman -S --noconfirm --needed libcddb  # Библиотека, реализующая различные протоколы (CDDBP, HTTP, SMTP) для доступа к данным на сервере CDDB (https://gnudb.org). https://archlinux.org/packages/extra/x86_64/libcddb/
sudo pacman -S --noconfirm --needed libcdio  # Библиотека ввода и управления компакт-дисками GNU. https://archlinux.org/packages/extra/x86_64/libcdio/
sudo pacman -S --noconfirm --needed libmad  # Высококачественный аудиодекодер MPEG. https://archlinux.org/packages/extra/x86_64/libmad/
sudo pacman -S --noconfirm --needed libpipewire  # Маршрутизатор и процессор аудио/видео с малой задержкой — клиентская библиотека. https://archlinux.org/packages/extra/x86_64/libpipewire/ https://archlinux.org/packages/extra-testing/x86_64/libpipewire/
sudo pacman -S --noconfirm --needed libpulse  # Многофункциональный универсальный звуковой сервер (клиентская библиотека). https://archlinux.org/packages/extra/x86_64/libpulse/
sudo pacman -S --noconfirm --needed libsamplerate # Библиотека преобразования частоты дискретизации звука. https://archlinux.org/packages/extra/x86_64/libsamplerate/
sudo pacman -S --noconfirm --needed libsndfile  # Библиотека AC для чтения и записи файлов, содержащих сэмплы аудиоданных. https://archlinux.org/packages/extra/x86_64/libsndfile/
sudo pacman -S --noconfirm --needed libvorbis  # Референсная реализация аудиоформата Ogg Vorbis. https://archlinux.org/packages/extra/x86_64/libvorbis/
sudo pacman -S --noconfirm --needed libx11  # Клиентская библиотека X11. https://archlinux.org/packages/extra/x86_64/libx11/
# sudo pacman -S --noconfirm --needed 
# sudo pacman -S --noconfirm --needed
# sudo pacman -S --noconfirm --needed   # 
################ AUR ##############
# yay -S deadbeef --noconfirm  # Интерфейс командной строки Git для GitHub. https://github.com/DeaDBeeF-Player/deadbeef
echo""
echo " Установка DeaDBeeF (Модульный аудиоплеер GTK для GNU/Linux) "
git clone https://aur.archlinux.org/deadbeef.git    # (только для чтения, нажмите, чтобы скопировать) https://aur.archlinux.org/packages/git-hub
cd deadbeef
#makepkg -fsri  
makepkg -si --noconfirm  #-не спрашивать каких-либо подтверждений
# makepkg -si
#makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)  
rm -Rf deadbeef  # удаляем директорию сборки
# rm -rf deadbeef 
echo " Установка DeaDBeeF завершена "

# -------------------------------------------------

# Если в системе не установлены необходимые зависимости, makepkg предупредит вас об этом и отменит сборку. Если задать флаг -s/--syncdeps, то makepkg самостоятельно установит недостающие зависимости и соберёт пакет.
# $ makepkg --syncdeps

# ---------------------------------------------------
# URL-адрес клона Git:	https://aur.archlinux.org/deadbeef.git (только чтение, нажмите, чтобы скопировать)
# https://aur.archlinux.org/packages/deadbeef?all_deps=1#pkgdeps
# База пакета: deadbeef
# URL восходящего направления:	https://deadbeef.sourceforge.io/
# Лицензии:	GPL2, zlib, LGPL2.1
# Последний упаковщик: FabioLolix
# Голоса:	84
# Популярность:	2.95
# Первый отправленный:	2021-05-08 09:08 (UTC)
# Последнее обновление:	2023-11-12 09:06 (UTC)
# https://github.com/DeaDBeeF-Player/deadbeef

# <<< Делайте выводы сами! >>>
#
