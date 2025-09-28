############# Справка Firejail ##############
# Firejail - ArchWiki:
# https://wiki.archlinux.org/title/Firejail
# Вики: https://github.com/netblue30/firejail/wiki
# Веб-страница проекта: https://firejail.wordpress.com/
# Загрузка и установка: https://firejail.wordpress.com/download-2/
# https://github.com/netblue30/firejail
# https://archlinux.org/packages/extra/x86_64/firejail/
# https://archlinux.org/packages/extra/x86_64/firetools/
# IRC: https://web.libera.chat/#firejail
# Документация: https://firejail.wordpress.com/documentation-2/
# Возможности: https://firejail.wordpress.com/features-3/
# Документация: https://firejail.wordpress.com/documentation-2/
# Часто задаваемые вопросы: https://github.com/netblue30/firejail/wiki/Frequently-Asked-Questions
# Действия GitHub: https://github.com/netblue30/firejail/actions
# GitLab CI: https://gitlab.com/Firejail/firejail_ci/pipelines
# Debian CI: https://salsa.debian.org/reiner/firejail
# Трекер пакетов Debian: https://tracker.debian.org/pkg/firejail
# PPA Ubuntu: https://launchpad.net/~deki/+archive/ubuntu/firejail
# Резервный видеоканал: https://www.bitchute.com/profile/JSBsA1aoQVfW/
#############################

ИМЯ
       Firejail — программа-песочница для пространств имен Linux

СИНОПСИС
       Запустить песочницу:

              firejail [ПАРАМЕТРЫ] [программа и аргументы]

       Запустите программу AppImage:

              firejail [ПАРАМЕТРЫ] --appimage [файл-образ-приложения и аргументы]

       Передача файлов из существующей песочницы

              firejail {--ls | --get | --put} имя_каталога_или_файла

       Формирование сетевого трафика для существующей «песочницы»:

              firejail --bandwidth={name|pid} пропускная способность-команда

       Мониторинг:

              firejail {--list | --netstats | --top | --tree}

       Разнообразный:

              firejail {-? | --debug-caps | --debug-errnos | --debug-syscalls | --debug-protocols | --help |
              --версия}


Запуск песочницы:
Чтобы запустить песочницу, добавьте к команде префикс firejail:

firejail firefox            # starting Mozilla Firefox
firejail transmission-gtk   # starting Transmission BitTorrent
firejail vlc                # starting VideoLAN Client
sudo firejail /etc/init.d/nginx start

Запустите firejail --list в терминале, чтобы получить список всех активных песочниц. Пример:

$ firejail --list
1617:netblue:/usr/bin/firejail /usr/bin/firefox-esr
7719:netblue:/usr/bin/firejail /usr/bin/transmission-qt
7779:netblue:/usr/bin/firejail /usr/bin/galculator
7874:netblue:/usr/bin/firejail /usr/bin/vlc --started-from-file file:///home/netblue/firejail-whitelist.mp4
7916:netblue:firejail --list

Интеграция с рабочим столом:
Интегрируйте свою песочницу в рабочий стол, выполнив следующие две команды:

firecfg --fix-sound
sudo firecfg

Первая команда исправляет некоторые ошибки общей памяти/пространства имён PID в PulseAudio до версии 9. Вторая команда интегрирует Firejail в ваш рабочий стол. Чтобы применить изменения PulseAudio, вам потребуется выйти из системы и войти снова.

Запускайте программы привычным для вас способом: меню менеджера рабочего стола, файловый менеджер, средства запуска рабочего стола.

Интеграция распространяется на все программы, поддерживаемые Firejail по умолчанию. В текущей версии Firejail более 900 стандартных приложений, и их число растёт с каждым новым релизом.

Интеграция с рабочим столом
Интегрируйте свою песочницу в рабочий стол, выполнив следующие две команды:

firecfg --fix-sound
sudo firecfg

Первая команда исправляет некоторые ошибки общей памяти/пространства имён PID в PulseAudio до версии 9. Вторая команда интегрирует Firejail в ваш рабочий стол. Чтобы применить изменения PulseAudio, вам потребуется выйти из системы и войти снова.

Запускайте программы привычным для вас способом: меню менеджера рабочего стола, файловый менеджер, средства запуска рабочего стола.

Интеграция распространяется на все программы, поддерживаемые Firejail по умолчанию. В текущей версии Firejail более 900 стандартных приложений, и их число растёт с каждым новым релизом.

Профили безопасности
Большинство параметров командной строки Firejail можно передать в «песочницу» с помощью файлов профилей.

Профили для всех поддерживаемых приложений можно найти в etc/ (/etc/firejail/ после установки).

Мы также храним список исправлений профиля для ранее выпущенных версий в etc-fixes/ .

Если вы храните дополнительные профили безопасности Firejail в публичном репозитории, пожалуйста, дайте нам ссылку:

https://github.com/chiraag-nataraj/firejail-profiles
https://github.com/triceratops1/fe
Используйте этот выпуск для запроса новых профилей:

Запросы профиля:
Вы также можете использовать этот инструмент для получения списка системных вызовов, необходимых программе:

contrib/syscalls.sh

Удаление
firecfg создает символические ссылки в /usr/local/bin, поэтому для полного удаления firejail выполните следующее перед деинсталляцией:

sudo firecfg --clean
man firecfgПодробности смотрите здесь .

Примечание: при поиске исполняемого файла в неработающие символические ссылки игнорируются $PATH, поэтому удаление без выполнения вышеуказанных действий не должно вызвать проблем.

Статистика профиля
Небольшая утилита для вывода статистики профиля. Компилируется и устанавливается как обычно. Утилита устанавливается в каталог /usr/lib/firejail.

Запустите его по профилям в /etc/profiles:

$ /usr/lib/firejail/profstats /etc/firejail/*.profile
No include .local found in /etc/firejail/noprofile.profile
Warning: multiple caps in /etc/firejail/tidal-hifi.profile
Warning: multiple caps in /etc/firejail/tqemu.profile
Warning: multiple caps in /etc/firejail/transmission-daemon.profile
Warning: cannot open youtube-music-desktop-app or /etc/firejail/youtube-music-desktop-app, while processing /etc/firejail/youtube-music-desktop-app.profile
No include .local found in /etc/firejail/youtube-music-desktop-app.profile

Stats:
    profiles			1325
    include local profile	1324   (include profile-name.local)
    include globals		1291   (include globals.local)
    blacklist ~/.ssh		1184   (include disable-common.inc)
    seccomp			1196
    capabilities		1318
    noexec			1198   (include disable-exec.inc)
    noroot			1093
    memory-deny-write-execute	320
    restrict-namespaces		1035
    apparmor			850
    private-bin			801
    private-dev			1224
    private-etc			824
    private-lib			85
    private-tmp			1021
    whitelist home directory	654
    whitelist var		965   (include whitelist-var-common.inc)
    whitelist run/user		1288   (include whitelist-runuser-common.inc
					or blacklist ${RUNUSER})
    whitelist usr/share		746   (include whitelist-usr-share-common.inc
    net none			450
    dbus-user none 		754
    dbus-user filter 		196
    dbus-system none 		956
    dbus-system filter 		13