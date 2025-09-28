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
# sudo pacman -R  --noconfirm   # --noconfirm   не спрашивать каких-либо подтверждений
### Недостающие зависимости ####
# sudo pacman -S --noconfirm --needed curl  # Инструмент командной строки и библиотека для передачи данных с помощью URL-адресов. https://archlinux.org/packages/core/x86_64/curl/
# sudo pacman -S --noconfirm --needed git  # Быстрая распределенная система контроля версий. https://archlinux.org/packages/extra/x86_64/git/
sudo pacman -S --noconfirm --needed alsa-lib  # Альтернативная реализация поддержки звука в Linux ; https://archlinux.org/packages/extra/x86_64/alsa-lib/ ; https://www.alsa-project.org/ ; Обеспечивает: libasound.so=2-64, libatopology.so=2-64 ; 2025-04-14 20:27 UTC
sudo pacman -S --noconfirm --needed gtk3  # Мультиплатформенный набор графических инструментов на основе GObject ; https://archlinux.org/packages/extra/x86_64/gtk3/ ; https://archlinux.org/packages/extra/x86_64/gtk3/ ; Обеспечивает: gtk3-print-backends, libgailutil-3.so=0-64, libgdk-3.so=0-64, libgtk-3.so=0-64 ; Заменяет: gtk3-print-backends<=3.22.26-1 ; Конфликты: с gtk3-print-backends ; 2025-08-10 14:21 UTC
sudo pacman -S --noconfirm --needed jansson  # Библиотека C для кодирования, декодирования и управления данными JSON ; https://archlinux.org/packages/core/x86_64/jansson/ ; https://www.digip.org/jansson/ ; 2025-03-31 20:07 UTC
sudo pacman -S --noconfirm --needed libdispatch  # Комплексная поддержка одновременного выполнения кода на многоядерном оборудовании ; https://archlinux.org/packages/extra/x86_64/libdispatch/ ; https://apple.github.io/swift-corelibs-libdispatch ; Обеспечивает: libblocksruntime ; 2025-04-01 17:55 UTC
sudo pacman -S --noconfirm --needed clang  # Интерфейс семейства языков C для LLVM ; https://archlinux.org/packages/extra/x86_64/clang/ ; https://clang.llvm.org/ ; Обеспечивает: clang-analyzer=20.1.8, clang-tools-extra=20.1.8 ; Заменяет: clang-analyzer, clang-tools-extra ; Конфликты: с clang-analyzer, clang-tools-extra ; 2025-07-15 21:01 UTC
sudo pacman -S --noconfirm --needed faad2  # Бесплатный декодер Advanced Audio (AAC) ; https://archlinux.org/packages/extra/x86_64/faad2/ ; https://github.com/knik0/faad2 ; Обеспечивает: faad, libfaad.so=2-64, libfaad_drm.so=2-64 ; 2025-03-04 09:01 UTC
#sudo pacman -S --noconfirm --needed vlc-plugin-faad2  # Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — плагин FAAD2 AAC ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-faad2/ ; https://www.videolan.org/vlc/ ; 2025-07-23 20:53 UTC
sudo pacman -S --noconfirm --needed ffmpeg  # Комплексное решение для записи, преобразования и потоковой передачи аудио и видео ; https://archlinux.org/packages/extra/x86_64/ffmpeg/ ; https://ffmpeg.org/ ; Обеспечивает: libavcodec.so=61-64, libavdevice.so=61-64, libavfilter.so=10-64, libavformat.so=61-64, libavutil.so=59-64, Подробнее… (https://archlinux.org/packages/extra/x86_64/ffmpeg/#); 2025-07-17 06:59 UTC
sudo pacman -S --noconfirm --needed flac  # Бесплатный аудиокодек без потерь ; https://archlinux.org/packages/extra/x86_64/flac/ ; https://xiph.org/flac/ ; Обеспечивает: libFLAC++.so=11-64, libFLAC.so=14-64 ; 2025-02-21 19:56 UTC
sudo pacman -S --noconfirm --needed imlib2  # Библиотека, которая выполняет загрузку и сохранение файлов изображений, а также рендеринг, манипуляцию и поддержку произвольных полигонов ; https://archlinux.org/packages/extra/x86_64/imlib2/ ; https://sourceforge.net/projects/enlightenment/ ; 2025-04-07 15:12 UTC
sudo pacman -S --noconfirm --needed intltool  # Коллекция инструментов интернационализации ; https://archlinux.org/packages/extra/any/intltool/ ; https://launchpad.net/intltool ; 2020-06-21 15:27 UTC
sudo pacman -S --noconfirm --needed libcddb  # Библиотека, реализующая различные протоколы (CDDBP, HTTP, SMTP) для доступа к данным на сервере CDDB (https://gnudb.org) ; https://archlinux.org/packages/extra/x86_64/libcddb/ ; https://sourceforge.net/projects/libcddb/ ; 2022-12-09 07:45 UTC
sudo pacman -S --noconfirm --needed libcdio  # Библиотека ввода и управления компакт-дисками GNU ; https://archlinux.org/packages/extra/x86_64/libcdio/ ; https://www.gnu.org/software/libcdio/ ; 2025-01-12 02:14 UTC
sudo pacman -S --noconfirm --needed libmad  # Высококачественный аудиодекодер MPEG ; https://archlinux.org/packages/extra/x86_64/libmad/ ; https://www.underbit.com/products/mad/ ; 2023-02-18 21:54 UTC
sudo pacman -S --noconfirm --needed libpipewire  # Аудио/видео маршрутизатор и процессор с малой задержкой — клиентская библиотека ; https://archlinux.org/packages/extra/x86_64/libpipewire/ ; https://pipewire.org/ ; Обеспечивает: libpipewire-0.3.so=0-64 ; 2025-07-26 01:14 UTC
sudo pacman -S --noconfirm --needed lib32-libpipewire  # Аудио/видео маршрутизатор и процессор с малой задержкой — 32-бит — клиентская библиотека ; https://archlinux.org/packages/multilib/x86_64/lib32-libpipewire/ ; https://pipewire.org/ ; Обеспечивает: libpipewire-0.3.so=0-32 ; 2025-07-26 01:13 UTC
sudo pacman -S --noconfirm --needed libpulse  # Функциональный универсальный звуковой сервер (клиентская библиотека) ; https://archlinux.org/packages/extra/x86_64/libpulse/ ; https://www.freedesktop.org/wiki/Software/PulseAudio/ ; Обеспечивает: libpulse-mainloop-glib.so=0-64, libpulse-simple.so=0-64, libpulse.so=0-64 ; 2024-12-07 17:14 UTC
#sudo pacman -S --noconfirm --needed lib32-libpulse  # Функциональный универсальный звуковой сервер (32-битные клиентские библиотеки) ; https://archlinux.org/packages/multilib/x86_64/lib32-libpulse/ ; https://www.freedesktop.org/wiki/Software/PulseAudio/ ; Обеспечивает: lib32-pulseaudio=17.0+r43+g3e2bb8a1e ; Заменяет: lib32-pulseaudio ; Конфликты: с lib32-pulseaudio ; 2024-12-07 17:12 UTC
sudo pacman -S --noconfirm --needed libsamplerate # Библиотека преобразования частоты дискретизации звука ; https://archlinux.org/packages/extra/x86_64/libsamplerate/ ; https://libsndfile.github.io/libsamplerate/ ; Обеспечивает: libsamplerate.so=0-64 ; 2024-07-12 21:15 UTC
sudo pacman -S --noconfirm --needed lib32-libsamplerate  # Библиотека преобразования частоты дискретизации звука ; https://archlinux.org/packages/multilib/x86_64/lib32-libsamplerate/ ; https://libsndfile.github.io/libsamplerate/ ; Обеспечивает: libsamplerate.so=0-32 ; 2024-09-07 11:54 UTC
sudo pacman -S --noconfirm --needed libsndfile  # Библиотека AC для чтения и записи файлов, содержащих сэмплированные аудиоданные ; https://archlinux.org/packages/extra/x86_64/libsndfile/ ; https://libsndfile.github.io/libsndfile/ ; Обеспечивает: libsndfile.so=1-64 ; 2025-02-21 19:56 UTC
sudo pacman -S --noconfirm --needed lib32-libsndfile  # Библиотека AC для чтения и записи файлов, содержащих сэмплированные аудиоданные (32 бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-libsndfile/ ; https://libsndfile.github.io/libsndfile/ ; Обеспечивает: libsndfile.so=1-32 ; 2025-02-21 19:55 UTC
sudo pacman -S --noconfirm --needed python-soundfile  # Библиотека Python для чтения и записи аудиофайлов с использованием libsndfile, CFFI и NumPy ; https://archlinux.org/packages/extra/any/python-soundfile/ ; https://github.com/bastibe/python-soundfile ; 2024-12-22 13:43 UTC
sudo pacman -S --noconfirm --needed libvorbis  # Эталонная реализация аудиоформата Ogg Vorbis ; https://archlinux.org/packages/extra/x86_64/libvorbis/ ; https://www.xiph.org/vorbis/ ; Обеспечивает: libvorbis.so=0-64, libvorbisenc.so=2-64, libvorbisfile.so=3-64 ; 2025-01-27 23:00 UTC
sudo pacman -S --noconfirm --needed lib32-libvorbis  # Эталонная реализация аудиоформата Ogg Vorbis (32 бита) ; https://archlinux.org/packages/multilib/x86_64/lib32-libvorbis/ ; https://www.xiph.org/vorbis/ ; Обеспечивает: libvorbis.so=0-32, libvorbisenc.so=2-32, libvorbisfile.so=3-32 ; 2025-01-27 23:00 UTC
sudo pacman -S --noconfirm --needed libvorbis-docs  # Эталонная реализация аудиоформата Ogg Vorbis (документация) ; https://archlinux.org/packages/extra/x86_64/libvorbis-docs/ ; https://www.xiph.org/vorbis/ ; 2025-01-27 23:00 UTC
sudo pacman -S --noconfirm --needed libx11  # Клиентская Библиотека управления сеансами X11 ; https://archlinux.org/packages/extra/x86_64/libsm/ ; https://xorg.freedesktop.org/ ; 2025-03-10 13:48 UTC
sudo pacman -S --noconfirm --needed lib32-libsm  # Библиотека управления сеансами X11 (32-бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-libsm/ ; https://xorg.freedesktop.org/ ; 2024-09-07 10:16 UTC
sudo pacman -S --noconfirm --needed mpg123  # (необязательно) – для воспроизведения MP1/MP2/MP3 ; Консольный проигрыватель MPEG Audio Player в реальном времени для уровней 1, 2 и 3 ; https://archlinux.org/packages/extra/x86_64/mpg123/ ; https://mpg123.de/ ; Обеспечивает: libmpg123.so=0-64, libout123.so=0-64, libsyn123.so=0-64 ; 28 июля 2025 г. 18:47 UTC
sudo pacman -S --noconfirm --needed lib32-mpg123  # (необязательно) – для воспроизведения MP1/MP2/MP3 ; Консольный проигрыватель MPEG Audio Player в реальном времени для уровней 1, 2 и 3 (32 бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-mpg123/ ; https://mpg123.de/ ; Обеспечивает: libmpg123.so=0-32, libout123.so=0-32, libsyn123.so=0-32 ; 2025-08-08 09:49 UTC
# sudo pacman -S --noconfirm --needed vlc-plugin-mpg123  # (необязательно) – для воспроизведения MP1/MP2/MP3 ; Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — плагин MPG1/2/3 ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-mpg123/ ; https://www.videolan.org/vlc/ ; 2025-07-23 20:53 UTC
sudo pacman -S --noconfirm --needed opus  # (необязательно) – для плагина opus ; Полностью открытый, бесплатный, очень универсальный аудиокодек ; https://archlinux.org/packages/extra/x86_64/opus/ ; https://www.opus-codec.org/ ; Обеспечивает: libopus.so=0-64 ; 2024-04-17 21:45 UTC
sudo pacman -S --noconfirm --needed opusfile  # (необязательно) – для плагина opus ; Библиотека для открытия, поиска и декодирования файлов .opus ; https://archlinux.org/packages/extra/x86_64/opusfile/ ; https://opus-codec.org/ ; 2024-07-13 02:06 UTC
sudo pacman -S --noconfirm --needed opus-tools  # Коллекция инструментов для аудиокодека Opus ; https://wiki.xiph.org/Opus-tools ; https://archlinux.org/packages/extra/x86_64/opus-tools/ ; 2025-02-21 19:56 UTC
sudo pacman -S --noconfirm --needed pulseaudio  # (необязательно) – для выходного плагина PulseAudio ; Функциональный универсальный звуковой сервер ; https://archlinux.org/packages/extra/x86_64/pulseaudio/ ; https://archlinux.org/packages/extra/x86_64/pulseaudio/ ; https://www.freedesktop.org/wiki/Software/PulseAudio/ ; Обеспечивает: pulse-native-провайдер ; Заменяет: pulseaudio-gconf<=11.1, pulseaudio-xen<=9.0 ; Конфликты: с  ; Обратные конфликты:  ; 2024-12-07 17:14 UTC
sudo pacman -S --noconfirm --needed wavpack  # (необязательно) – для плагина wavpack ; Формат сжатия аудио с режимами сжатия без потерь, с потерями и гибридным ; https://archlinux.org/packages/extra/x86_64/wavpack/ ; https://www.wavpack.com/ ; 2025-01-28 20:19 UTC
sudo pacman -S --noconfirm --needed lib32-wavpack  # (необязательно) – для плагина wavpack ; Формат сжатия аудио с режимами сжатия без потерь, с потерями и гибридным (32 бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-wavpack/ ; http://www.wavpack.com/ ; 2025-01-30 21:23 UTC
sudo pacman -S --noconfirm --needed yasm  # (необязательно) – требуется для сборки частей сборки плагина ffap ; Переписанный NASM для поддержки нескольких синтаксисов (NASM, TASM, GAS и т. д.) ; https://archlinux.org/packages/extra/x86_64/yasm/ ; https://www.tortall.net/projects/yasm/ ; 2025-05-19 22:39 UTC
sudo pacman -S --noconfirm --needed zlib # (необязательно) – для плагина Audio Overload (psf, psf2 и т. д.), GME (для vgz) ; Библиотека сжатия, реализующая метод сжатия deflate, используемый в gzip и PKZIP ; https://archlinux.org/packages/core/x86_64/zlib/ ; https://www.zlib.net/ ; 2024-05-03 07:02 UTC
sudo pacman -S --noconfirm --needed libzip # (необязательно) – для плагина vfs_zip ; Библиотека C для чтения, создания и изменения zip-архивов ; https://archlinux.org/packages/extra/x86_64/libzip/ ; https://libzip.org/ ; Обеспечивает: libzip.so=5-64 ; 2025-05-25 07:16 UTC
# sudo pacman -S --noconfirm --needed
# sudo pacman -S --noconfirm --needed
# sudo pacman -S --noconfirm --needed
################ DeaDBeeF (deadbeef) AUR ##############
############ deadbeef ##########
#yay -S deadbeef --noconfirm  # Модульный аудиоплеер GTK для GNU/Linux ; https://aur.archlinux.org/packages/deadbeef ;  ; https://github.com/DeaDBeeF-Player/deadbeef
############ deadbeef ##########
#echo""
#echo " Установка DeaDBeeF (Модульный аудиоплеер GTK для GNU/Linux) "
#git clone https://aur.archlinux.org/deadbeef.git    # (только для чтения, нажмите, чтобы скопировать) https://aur.archlinux.org/packages/git-hub
#cd deadbeef
# makepkg -fsri
#makepkg -si --noconfirm  #-не спрашивать каких-либо подтверждений
# makepkg -si
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
#rm -Rf deadbeef  # удаляем директорию сборки
# rm -rf deadbeef
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
  echo ""
  echo " Установка дополнительных плагинов "
########### deadbeef-plugin-discord-git ############
yay -S deadbeef-plugin-discord-git --noconfirm  # Плагин DeaDBeeF Discord для расширенного присутствия (Плагин Discord Rich Presence отображает текущий воспроизводимый трек в вашем статусе Discord) ; Плагин подключается к Discord через Discord Rich Presence API, дополнительная аутентификация не требуется. Вы можете настроить отображаемую информацию в настройках плагина https://deadbeef.sourceforge.io/plugins.html ; https://aur.archlinux.org/packages/deadbeef-plugin-discord-git ; https://aur.archlinux.org/deadbeef-plugin-discord-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/kuba160/ddb_discord_presence ; 2024-11-02 03:11 (UTC)
########### deadbeef-plugin-discord-git ############
#git clone https://aur.archlinux.org/deadbeef-plugin-discord-git.git  # (только для чтения, нажмите, чтобы скопировать)
#cd deadbeef-plugin-discord-git
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf deadbeef-plugin-discord-git
#rm -Rf deadbeef-plugin-discord-git
########### deadbeef-plugin-statusnotifier ############
yay -S deadbeef-plugin-statusnotifier --noconfirm  # Плагин для DeaDBeeF, который заменяет значок в трее по умолчанию на тот, который поддерживает протокол StatusNotifierIitem ; https://aur.archlinux.org/packages/deadbeef-plugin-statusnotifier ; https://aur.archlinux.org/deadbeef-plugin-statusnotifier.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/vovochka404/deadbeef-statusnotifier-plugin ; 2025-05-25 10:40 (UTC)
### Этот плагин нацелен на реализацию StatusNotifierItem для DeaDBeeF. Он призван заменить стандартный значок в трее в средах рабочего стола, поддерживающих протокол StatusNotifierIitem. Он также предназначен для предоставления значка в трее для deadbeef в средах рабочего стола, где старые значки xmbedded больше не поддерживаются, например, KDE Plasma 5, GNOME (3+), Cinnamon и т. д.
########### deadbeef-plugin-statusnotifier ############
#git clone https://aur.archlinux.org/deadbeef-plugin-statusnotifier.git  # (только для чтения, нажмите, чтобы скопировать)
#cd deadbeef-plugin-statusnotifier
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf deadbeef-plugin-statusnotifier
#rm -Rf deadbeef-plugin-statusnotifier
  echo ""
  echo " Посмотрите информацию о версии (deadbeef) "
sudo deadbeef --version  # Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "

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
