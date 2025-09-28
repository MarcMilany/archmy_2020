Grub-Customizer
https://forum.manjaro.org/t/grub-customizer/172612

См. также: Grub Arch Wiki
https://wiki.archlinux.org/title/GRUB

Настройщик Grub — спорный вопрос, однако общее мнение таково, что он представляет собой плохой пример привлекательного графического интерфейса для новичков.

Это потенциально опасно и совершенно не нужно. Это добавляет уровни сложности к загрузчику, критически важному для системы. Это не делает ничего, чего нельзя было бы достичь другими способами.

Несмотря на эти опасения, тот факт, что некоторые люди используют его, не сталкиваясь с проблемами, просто увековечивает невежество.

Почему бы не использовать Grub-Customizer?
Еще больше ненависти к Grub-Customizer.
:лампочка:Советы
Основной файл конфигурации для GRUB генерируется автоматически программой grub-mkconfig — его не следует редактировать напрямую (он находится по адресу /boot/grub/grub.cfg).

Вместо этого измените файл /etc/default/grub, чтобы внести изменения, которые будут отражены в сгенерированной конфигурации.

:лампочка:Вам не нужно добавлять префикс SUDO для каждого редактора (micro, kate — sudo не требуется)
1. Измените тайм-аут GRUB:
Редактировать/etc/default/grub
Отредактируйте следующие значения: время и то, скрыто ли оно.
# Timeout can range from -1 to any positive integer (-1: indefinite, 0: immediate, default: 5).
GRUB_TIMEOUT=5

# Boolean: True or False (default: false)
GRUB_HIDDEN_TIMEOUT_QUIET=false

2. Измените загрузку по умолчанию:
Редактировать/etc/default/grub

# GRUB_DEFAULT  (Accepts boot id, term 'saved' to load the previous selection, or numeral array)
# (Using an array 0 is the first, 1 is the second etc).
GRUB_DEFAULT=0

3. Измените параметры ядра
Пример: добавьте «nomodeset»
РЕДАКТИРОВАТЬ:/etc/default/grub

GRUB_CMDLINE_LINUX="quiet splash"
GRUB_CMDLINE_LINUX="quiet splash nomodeset"`

4. Настройте внешний вид
Установить фоновое изображение:

редактировать /etc/default/grub
GRUB_BACKGROUND=/path/to/your/image.jpg
GRUB_COLOR_NORMAL="light-blue/black" 
GRUB_COLOR_HIGHLIGHT="white/black"
GRUB_FONT="/boot/grub/fonts/myfont.pf2"

5. Обновите Grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

#####################################
Мудрые пользователи не должны использовать Grub-Customizer. Это моё личное заключение. Я считаю, что использовать его следует только тем, кто может прочитать и понять сгенерированный grub.cfg.

Полагаю, привлекательность в том, что легко менять темы и т.п.? Если вы понимаете, то, думаю, редактировать в редакторе проще.

Я задал тему для Grub с помощью больших букв. Ниже — просто мой пример.

font = "Impact Regular 800" # countdown num.

# GRUB_THEME="/usr/share/grub/themes/manjaro/theme.txt"
GRUB_THEME="/boot/grub/themes/zen4k/theme.txt"
# GRUB_THEME="/boot/grub/themes/bootfield/theme.txt"

zen4k/theme принадлежит только мне. Его нет в AUR.

ls /boot/grub/themes/
bootfield bootfield_manjaro graphite-default-4k graphite-nord-4k starfield stylish-color-4k zen4k
#######################################

Как установить «nomodeset» после установки Ubuntu?
Вам следует добавить эту опцию в/etc/default/grub, во-первых:
sudo nano /etc/default/grub
а затем добавитьnomodesetкGRUB_CMDLINE_LINUX_DEFAULT:
GRUB_DEFAULT=0
GRUB_HIDDEN_TIMEOUT=0
GRUB_HIDDEN_TIMEOUT_QUIET=true
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash nomodeset"
GRUB_CMDLINE_LINUX=""

Быстро исправить проблему чёрного экрана и запустить Linux нам поможет добавление параметра «nomodeset» в стандартный загрузчик GRUB (GRAND Unified Bootloader). Параметр «nomodeset» указывает ядру не запускать видеодрайверы до тех пор, пока система не будет загружена.

Что означают параметры quiet и splash?
Обычным пользователям не очень интересно наблюдать за выводом текстовой информации о процессе загрузки, многих она даже пугает. По этой причине, при загрузке Linux на десктопах обычно отображается Splash Screen (графический экран) с логотипом и какой-нибудь анимацией. Вот чтобы всё выглядело по красоте и существуют параметры ядра quiet и splash.

Если удалить параметр quiet (его ещё называют "молчаливым режимом"), то запуск Linux будет сопровождаться информационными сообщениями на экране о процессе загрузки — со статусом [OK], если все идет хорошо или [Fail], если что-то не так.

Убрав параметр splash можно вообще отключить графический режим Splash Screen из опций загрузки ядра, таким образом оставив пустым значение параметра GRUB_CMDLINE_LINUX_DEFAULT в файле конфигурации загрузчика GRUB — /etc/default/grub.

GRUB_CMDLINE_LINUX_DEFAULT=""

Вообще, существует множество других параметров загрузки передаваемых ядру Linux и они могут различаться от версии к версии, но это уже отдельная большая тема.
