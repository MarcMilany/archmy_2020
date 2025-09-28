############# Справка по Btop++ и Bashtop ##############

https://github.com/aristocratos/btop

https://github.com/aristocratos/bashtop


Темы для Btop++ :
Btop++ использует те же файлы тем, что и bpytop и bashtop (некоторые значения цветов отсутствуют в темах bashtop).
Доступные темы смотрите в папке «Темы».
Btop ищет системные темы в следующих каталогах:
 ../share/btop/themes(этот путь указан относительно исполняемого файла btop)
  /usr/local/share/btop/themes
  /usr/share/btop/themes
 Первый существующий и непустой каталог используется в качестве каталога системных тем.
 Каталог пользовательских тем зависит от того, какие переменные среды установлены:
 Если $XDG_CONFIG_HOME установлено, каталог пользовательских тем $XDG_CONFIG_HOME/btop/themes
 В противном случае, если $HOMEустановлено, каталог пользовательских тем $HOME/.config/btop/themes
 В противном случае каталог пользовательских тем будет ~/.config/btop/themes
 Команда make installпомещает темы по умолчанию в [$PREFIX or /usr/local]/share/btop/themes. Темы, созданные пользователем, следует помещать в каталог пользовательских тем.
 Дайте мне знать, если вы хотите предложить новые темы.
 Если появилась ошибка “No UTF-8 locale detected”
 * На Arch Linux может появиться такая ошибка при запуске:
 ERROR: No UTF-8 locale detected!
 Use --force-utf argument to force start if you're sure your terminal can handle it.
 Копировать:
 Решается двумя способами:
 1. временно:
  btop --force-utf
 Копировать
 2. постоянно — добавьте в файл ~/.bashrc:
 export LANG=en_US.UTF-8
 Копировать
 Как запустить Btop++
 Просто откройте терминал и введите:
 btop
 Если у вас окружение вроде GNOME, то и в меню приложений он тоже появится.
 Интерфейс Btop++ :
 Когда вы запустите Btop++, обратите внимание на цветные буквы в заголовках разделов — это горячие клавиши.
Например, нажав клавишу m, вы попадёте в главное меню. Там выберите пункт Options, и откроется окно с настройками интерфейса.
Навигация осуществляется стрелками и клавишами, выделенными цветом. Изменения применяются сразу.
Полезные функции Btop:
— Завершить процесс: переместитесь к нужному процессу стрелками вверх-вниз и нажмите t — процесс будет завершён.
— Подробнее о процессе: нажмите Enter, чтобы открыть выбранный процесс в отдельном окне со статистикой: статус, загруженность CPU, время работы и другое.
— отправить сигнал процессу: наведитесь на процесс, нажмите s, введите нужный номер сигнала — и всё.
 В заключение:
 Многие предпочитают htop вместо top, и это оправдано. Но Btop++ — отличная альтернатива. Он быстрее, удобнее, с красивым интерфейсом и поддерживает мышь. Если вам не нравятся громоздкие графические мониторы, но хочется видеть всё сразу — обязательно попробуйте Btop++.

##################################

Конфигурируемость
Все параметры можно изменить через интерфейс. Файлы конфигурации хранятся в папке "$HOME/.config/bashtop".

bashtop.cfg: (автоматически генерируется, если не найден)
#? Config file for bashtop v. 0.9.21

#* Color theme, looks for a .theme file in "$HOME/.config/bashtop/themes" and "$HOME/.config/bashtop/user_themes"
#* Should be prefixed with either "themes/" or "user_themes/" depending on location, "Default" for builtin default theme
color_theme="Default"

#* Update time in milliseconds, increases automatically if set below internal loops processing time, recommended 2000 ms or above for better sample times for graphs
update_ms="2500"

#* Processes sorting, "pid" "program" "arguments" "threads" "user" "memory" "cpu lazy" "cpu responsive"
#* "cpu lazy" updates sorting over time, "cpu responsive" updates sorting directly
proc_sorting="cpu lazy"

#* Reverse sorting order, "true" or "false"
proc_reversed="false"

#* Show processes as a tree
proc_tree="false"

#* Check cpu temperature, only works if "sensors", "vcgencmd" or "osx-cpu-temp" commands is available
check_temp="true"

#* Draw a clock at top of screen, formatting according to strftime, empty string to disable
draw_clock="%X"

#* Update main ui when menus are showing, set this to false if the menus is flickering too much for comfort
background_update="true"

#* Custom cpu model name, empty string to disable
custom_cpu_name=""

#* Enable error logging to "$HOME/.config/bashtop/error.log", "true" or "false"
error_logging="true"

#* Show color gradient in process list, "true" or "false"
proc_gradient="true"

#* If process cpu usage should be of the core it's running on or usage of the total available cpu power
proc_per_core="false"

#* Optional filter for shown disks, should be names of mountpoints, "root" replaces "/", separate multiple values with space
disks_filter=""

#* Enable check for new version from github.com/aristocratos/bashtop at start
update_check="true"

#* Enable graphs with double the horizontal resolution, increases cpu usage
hires_graphs="false"

#* Enable the use of psutil python3 module for data collection, default on OSX
use_psutil="true"
Параметры командной строки: (пока не реализованы)
USAGE: bashtop
TODO
Возможно, я закончу дела не по порядку, так как обычно работаю над несколькими делами одновременно.

Добавьте возможности изменения цветов текста, графиков и счетчиков.

Исправление кроссплатформенной совместимости для Mac OSX и *BSD: Работаем на OSX и FreeBSD.

Добавить поддержку отображения температуры процессора AMD.

Добавить возможность отображения древовидной структуры процессов.

Добавить возможность сброса общих показателей загрузки/выгрузки по сети.

Добавить возможность поворота градиента в списке процессов.

Добавьте температуру и использование графического процессора. (Если это возможно)

Добавьте статистику ввода-вывода для дисков.

Добавьте статистику ЦП и памяти для контейнеров Docker. (Если это возможно)

Измените список процессов на прокрутку строк вместо смены страниц.

Добавить дополнительное окно для отслеживания файлов журнала.

Добавьте возможности изменения размера всех полей.

Добавить разбор аргументов командной строки.

Встроенный апдейтер. Актуальный PR #96 от Jukoo.

Добавить поддержку ZRAM в модуль памяти. Актуальный PR №122 от perkinslr.

Различные оптимизации и очистка кода.

Добавьте больше комментариев там, где их мало.

Порт Python. (Портирование началось)











