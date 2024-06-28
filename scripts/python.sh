#!/bin/bash
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 
  echo ""
  echo " Обновим базы данных пакетов... "
# sudo pacman -Sy --noconfirm  # обновить списки пакетов из репозиториев
  sudo pacman -Syy  # обновление баз пакмэна (pacman)
  echo ""
  echo " Обновление базы данных выполнено "
echo ""
echo " Установка - Python "
########## Python ###########
# sudo pacman -S python python2 python-anytree python-appdirs python-arrow python-asn1crypto python-atspi python-attrs python-bcrypt python-beaker python-beautifulsoup4 python-cachecontrol python-cffi python-cairo python-chardet python-colorama python-colour python-configobj python-contextlib2 python-cryptography python-cssselect python-d2to1 python-dateutil python-dbus python-dbus-common python-defusedxml python-distlib python-distro python-distutils-extra python-docopt python-entrypoints python-ewmh python-eyed3 python-future python-gevent python-gevent-websocket python-greenlet python-gobject python-html5lib python-httplib2 python-idna python-isodate python-isomd5sum python-jedi python-jeepney python-jinja python-keyring python-keyutils python-libarchive-c python-lxml python-lxml-docs python-magic python-mako python-markdown python-markupsafe python-maxminddb python-msgpack python-mutagen python-nose python-numpy python-olefile python-ordered-set python-packaging python-paramiko python-parso python-patiencediff python-pbr python-pep517 python-pillow python-pip python-pexpect python-ply python-powerline python-progress python-psutil python-ptyprocess python-pyasn1 python-pyasn1-modules python-pycountry python-pycparser python-pycups python-pycurl python-pycryptodome python-pyelftools python-pyfiglet python-pygments python-pyicu python-pynacl python-pyopenssl python-pyparsing python-pyphen python-pyqt5 python-pyqt5-sip python-pyquery python-pysmbc python-pysocks python-pysol_cards python-pyudev python-pywal python-pyxdg python-random2 python-requests python-resolvelib python-retrying python-rsa python-scipy python-secretstorage python-setproctitle python-setuptools python-shiboken2 python-sip python-six python-soupsieve python-sqlalchemy python-termcolor python-tlsh python-toml python-ujson python-unidecode python-urllib3 python-webencodings python-websockets websocket-client python-xapp python-yaml python-zope-event python-zope-interface --noconfirm  # python ; python2 ; python-pip (возможно присутствует)
# sudo pacman -S --noconfirm --needed python python2 python-anytree python-appdirs python-arrow python-asn1crypto python-atspi python-attrs python-bcrypt python-beaker python-beautifulsoup4 python-cachecontrol python-cffi python-cairo python-chardet python-colorama python-colour python-configobj python-contextlib2 python-cryptography python-cssselect python-d2to1 python-dateutil python-dbus python-dbus-common python-defusedxml python-distlib python-distro python-distutils-extra python-docopt python-entrypoints python-ewmh python-eyed3 python-future python-gevent python-gevent-websocket python-greenlet python-gobject python-html5lib python-httplib2 python-idna python-isodate python-isomd5sum python-jedi python-jeepney python-jinja python-keyring python-keyutils python-libarchive-c python-lxml python-lxml-docs python-magic python-mako python-markdown python-markupsafe python-maxminddb python-msgpack python-mutagen python-nose python-numpy python-olefile python-ordered-set python-packaging python-paramiko python-parso python-patiencediff python-pbr python-pep517 python-pillow python-pip python-pexpect python-ply python-powerline python-progress python-psutil python-ptyprocess python-pyasn1 python-pyasn1-modules python-pycountry python-pycparser python-pycups python-pycurl python-pycryptodome python-pyelftools python-pyfiglet python-pygments python-pyicu python-pynacl python-pyopenssl python-pyparsing python-pyphen python-pyqt5 python-pyqt5-sip python-pyquery python-pysmbc python-pysocks python-pysol_cards python-pyudev python-pywal python-pyxdg python-random2 python-requests python-resolvelib python-retrying python-rsa python-scipy python-secretstorage python-setproctitle python-setuptools python-shiboken2 python-sip python-six python-soupsieve python-sqlalchemy python-termcolor python-tlsh python-toml python-ujson python-unidecode python-urllib3 python-webencodings python-websockets websocket-client python-xapp python-yaml python-zope-event python-zope-interface
#####################
sudo pacman -S --noconfirm --needed python  # Новое поколение языка сценариев высокого уровня Python # возможно присутствует
# sudo pacman -S python --noconfirm  # Новое поколение языка сценариев высокого уровня Python
sudo pacman -S --noconfirm --needed python2  # Язык сценариев высокого уровня Python (Конфликты: python <3) # возможно присутствует
sudo pacman -S python-anytree --noconfirm  # Мощная и легкая древовидная структура данных Python
sudo pacman -S python-appdirs --noconfirm  # Небольшой модуль Python для определения соответствующих директорий для конкретной платформы, например «директории пользовательских данных».
sudo pacman -S python-arrow --noconfirm  # Лучшие даты и время для Python
sudo pacman -S python-asn1crypto --noconfirm  # Библиотека Python ASN.1 с упором на производительность и pythonic API
sudo pacman -S python-atspi --noconfirm  #  Привязки Python для D-Bus AT-SPI
sudo pacman -S python-attrs --noconfirm  # Атрибуты без шаблона
sudo pacman -S python-bcrypt --noconfirm  # Современное хеширование паролей для вашего программного обеспечения и ваших серверов
sudo pacman -S python-beaker --noconfirm  # Кэширование и сеансы промежуточного программного обеспечения WSGI для использования с веб-приложениями и автономными скриптами и приложениями Python
sudo pacman -S python-beautifulsoup4 --noconfirm  # Синтаксический анализатор HTML / XML на Python, предназначенный для быстрых проектов, таких как очистка экрана
sudo pacman -S python-cachecontrol --noconfirm  # httplib2 кеширование запросов
sudo pacman -S python-cffi --noconfirm  # Интерфейс внешних функций для Python, вызывающего код C
sudo pacman -S python-cairo --noconfirm  # Привязки Python для графической библиотеки cairo
sudo pacman -S python-chardet --noconfirm  # Модуль Python3 для автоматического определения кодировки символов
sudo pacman -S python-colorama --noconfirm  # Python API для кроссплатформенного цветного текста терминала
sudo pacman -S python-colour --noconfirm  # Библиотека манипуляций с цветовыми представлениями (RGB, HSL, web, ...)
sudo pacman -S python-configobj --noconfirm  # Простое, но мощное средство чтения и записи конфигурационных файлов для Python
sudo pacman -S python-contextlib2 --noconfirm  # Обратный перенос модуля contextlib стандартной библиотеки на более ранние версии Python
sudo pacman -S python-cryptography --noconfirm  # Пакет, предназначенный для предоставления криптографических рецептов и примитивов разработчикам Python
sudo pacman -S python-cssselect --noconfirm  # Библиотека Python3, которая анализирует селекторы CSS3 и переводит их в XPath 1.0
sudo pacman -S python-d2to1 --noconfirm  # Библиотека Python, которая позволяет использовать файлы setup.cfg, подобные distutils2, для метаданных пакета с помощью скрипта distribute / setuptools setup.py
sudo pacman -S python-dateutil --noconfirm  # Предоставляет мощные расширения для стандартного модуля datetime 
sudo pacman -S python-dbus --noconfirm  # Привязки Python для DBUS
sudo pacman -S python-dbus-common --noconfirm  # Общие файлы dbus-python, общие для python-dbus и python2-dbus
sudo pacman -S python-defusedxml --noconfirm  # Защита от XML-бомбы для модулей Python stdlib
sudo pacman -S python-distlib --noconfirm  # Низкоуровневые компоненты distutils2 / упаковка
sudo pacman -S python-distro --noconfirm  # API информации о платформе ОС Linux
sudo pacman -S python-distutils-extra --noconfirm  # Улучшения в системе сборки Python
sudo pacman -S python-docopt --noconfirm  # Пифонический парсер аргументов, который заставит вас улыбнуться
sudo pacman -S python-entrypoints --noconfirm  # Обнаружение и загрузка точек входа из установленных пакетов
sudo pacman -S python-ewmh --noconfirm  # Реализация Python подсказок Extended Window Manager на основе Xlib
sudo pacman -S python-eyed3 --noconfirm  # Модуль Python и программа для обработки информации о файлах mp3
sudo pacman -S python-future --noconfirm  # Чистая поддержка одного источника для Python 3 и 2
sudo pacman -S python-gevent --noconfirm  # Сетевая библиотека Python, которая использует greenlet и libev для простого и масштабируемого параллелизма
sudo pacman -S python-gevent-websocket --noconfirm  # Библиотека WebSocket для сетевой библиотеки gevent
sudo pacman -S python-greenlet --noconfirm  # Легкое параллельное программирование в процессе
sudo pacman -S python-gobject --noconfirm  # Привязки Python для GLib / GObject / GIO / GTK +
sudo pacman -S python-html5lib --noconfirm  # Парсер / токенизатор HTML Python на основе спецификации WHATWG HTML5
sudo pacman -S python-httplib2 --noconfirm  # Обширная клиентская библиотека HTTP, поддерживающая множество функций
sudo pacman -S python-idna --noconfirm  # Интернационализированные доменные имена в приложениях (IDNA)
sudo pacman -S python-isodate --noconfirm  # Синтаксический анализатор даты / времени / продолжительности и форматирование ISO 8601
sudo pacman -S --noconfirm --needed python-isomd5sum  # Привязки Python3 для isomd5sum # возможно присутствует
sudo pacman -S python-jedi --noconfirm  # Отличное автозаполнение для Python
sudo pacman -S python-jeepney --noconfirm  # Низкоуровневая оболочка протокола Python DBus на чистом уровне
sudo pacman -S python-jinja --noconfirm  # Простой питонический язык шаблонов, написанный на Python
sudo pacman -S python-keyring --noconfirm  # Безопасное хранение и доступ к вашим паролям
sudo pacman -S python-keyutils --noconfirm  # Набор привязок python для keyutils
sudo pacman -S python-libarchive-c --noconfirm  # Интерфейс Python для libarchive
sudo pacman -S python-lxml --noconfirm  # Связывание Python3 для библиотек libxml2 и libxslt (-S python-lxml --force # принудительная установка)
sudo pacman -S python-lxml-docs --noconfirm  # Связывание Python для библиотек libxml2 и libxslt (документы)
sudo pacman -S python-magic --noconfirm  # Привязки Python к волшебной библиотеке
sudo pacman -S python-mako --noconfirm  # Сверхбыстрый язык шаблонов, который заимствует лучшие идеи из существующих языков шаблонов
sudo pacman -S python-markdown --noconfirm  # Реализация Python Markdown Джона Грубера
sudo pacman -S python-markupsafe --noconfirm  # Реализует безопасную строку разметки XML / HTML / XHTML для Python
sudo pacman -S python-maxminddb --noconfirm  # Читатель для формата MaxMind DB
sudo pacman -S python-msgpack --noconfirm  # Реализация сериализатора MessagePack для Python
sudo pacman -S python-mutagen --noconfirm  # (mutagen) Средство чтения и записи тегов метаданных аудио (библиотека Python)
sudo pacman -S python-nose --noconfirm  # Расширение unittest на основе обнаружения
sudo pacman -S python-numpy --noconfirm  # Научные инструменты для Python
sudo pacman -S python-olefile --noconfirm  # Библиотека Python для анализа, чтения и записи файлов Microsoft OLE2 (ранее OleFileIO_PL)
sudo pacman -S python-ordered-set --noconfirm  # MutableSet, который запоминает свой порядок, так что каждая запись имеет индекс
sudo pacman -S python-packaging --noconfirm  # Основные утилиты для пакетов Python
sudo pacman -S python-paramiko --noconfirm  # Модуль Python, реализующий протокол SSH2
sudo pacman -S python-parso --noconfirm  # Синтаксический анализатор Python, поддерживающий восстановление ошибок и двусторонний синтаксический анализ для разных версий Python
sudo pacman -S python-patiencediff --noconfirm  # Patiencediff реализации Python и C
sudo pacman -S python-pbr --noconfirm  # Разумность сборки Python
sudo pacman -S python-pep517 --noconfirm  # Оболочки для сборки пакетов Python с использованием хуков PEP 517
sudo pacman -S python-pillow --noconfirm  # Вилка Python Imaging Library (PIL)
sudo pacman -S --noconfirm --needed python-pip  # Рекомендуемый PyPA инструмент для установки пакетов Python # возможно присутствует
sudo pacman -S python-pexpect --noconfirm  # Для управления и автоматизации приложений
sudo pacman -S python-ply --noconfirm  # Реализация инструментов парсинга lex и yacc
sudo pacman -S python-powerline --noconfirm  # Библиотека Python для Powerline
sudo pacman -S python-progress --noconfirm  # Простые в использовании индикаторы выполнения для Python
sudo pacman -S python-psutil --noconfirm  # Кросс-платформенный модуль процессов и системных утилит для Python
sudo pacman -S python-ptyprocess --noconfirm  # Запустить подпроцесс в псевдотерминале
sudo pacman -S python-pyasn1 --noconfirm  # Библиотека ASN.1 для Python 3
sudo pacman -S python-pyasn1-modules --noconfirm  # Коллекция модулей протоколов на основе ASN.1
sudo pacman -S python-pycountry --noconfirm  # Определения страны, подразделения, языка, валюты и алфавита ИСО и их переводы
sudo pacman -S python-pycparser --noconfirm  # Синтаксический анализатор C и генератор AST, написанные на Python
sudo pacman -S python-pycups --noconfirm  # Привязки Python для libcups
sudo pacman -S python-pycurl --noconfirm  # Интерфейс Python 3.x для libcurl
sudo pacman -S python-pycryptodome --noconfirm  # Коллекция криптографических алгоритмов и протоколов, реализованных для использования из Python 3
sudo pacman -S python-pyelftools --noconfirm  # Библиотека Python для анализа файлов ELF и отладочной информации DWARF
sudo pacman -S python-pyfiglet --noconfirm  # Реализация FIGlet на чистом питоне
sudo pacman -S python-pygments --noconfirm  # Подсветка синтаксиса Python
sudo pacman -S python-pyicu --noconfirm  # Связывание Python для ICU
sudo pacman -S python-pynacl --noconfirm  # Привязка Python к библиотеке сетей и криптографии (NaCl)
sudo pacman -S python-pyopenssl --noconfirm  # Модуль оболочки Python3 вокруг библиотеки OpenSSL
sudo pacman -S python-pyparsing --noconfirm  # Модуль общего синтаксического анализа для Python
sudo pacman -S python-pyphen --noconfirm  # Модуль Pure Python для переноса текста
sudo pacman -S python-pyqt5 --noconfirm  # Набор привязок Python для инструментария Qt5
sudo pacman -S python-pyqt5-sip --noconfirm  # Поддержка модуля sip для PyQt5
sudo pacman -S python-pyquery --noconfirm  # Библиотека для Python, похожая на jquery
sudo pacman -S python-pysmbc --noconfirm  # Привязки Python 3 для libsmbclient
sudo pacman -S python-pysocks --noconfirm  # SOCKS4, SOCKS5 или HTTP-прокси (вилка Anorov PySocks заменяет socksipy)
sudo pacman -S python-pysol_cards --noconfirm  # Карты Deal PySol FC
sudo pacman -S python-pyudev --noconfirm  # Привязки Python к libudev
sudo pacman -S python-pywal --noconfirm  # Создавайте и изменяйте цветовые схемы на лету
sudo pacman -S python-pyxdg --noconfirm  # Библиотека Python для доступа к стандартам freedesktop.org
sudo pacman -S python-random2 --noconfirm  # Python 3 совместимый порт случайного модуля Python 2
sudo pacman -S python-requests --noconfirm  # Python HTTP для людей
sudo pacman -S python-resolvelib --noconfirm  # Преобразуйте абстрактные зависимости в конкретные
sudo pacman -S python-retrying --noconfirm  # Библиотека перенастройки Python общего назначения
sudo pacman -S python-rsa --noconfirm  # Реализация RSA на чистом Python
sudo pacman -S python-scipy --noconfirm  # SciPy - это программное обеспечение с открытым исходным кодом для математики, естественных наук и инженерии
sudo pacman -S python-secretstorage --noconfirm  # Безопасно храните пароли и другие личные данные с помощью API SecretService DBus
sudo pacman -S python-setproctitle --noconfirm  # Позволяет процессу Python изменять название процесса
sudo pacman -S python-setuptools --noconfirm  # Легко загружайте, собирайте, устанавливайте, обновляйте и удаляйте пакеты Python
sudo pacman -S python-shiboken2 --noconfirm  # Создает привязки для библиотек C ++ с использованием исходного кода CPython
sudo pacman -S python-sip --noconfirm  # Привязки Python SIP4 для библиотек C и C ++ (python-sip4)
sudo pacman -S python-six --noconfirm  # Утилиты совместимости с Python 2 и 3
sudo pacman -S python-soupsieve --noconfirm  # Реализация селектора CSS4 для Beautiful Soup
sudo pacman -S python-sqlalchemy --noconfirm  # Набор инструментов Python SQL и объектно-реляционное сопоставление
sudo pacman -S python-termcolor --noconfirm  # Форматирование цвета ANSII для вывода в терминал
sudo pacman -S python-tlsh --noconfirm  # Библиотека нечеткого сопоставления, которая генерирует хеш-значение, которое можно использовать для сравнений схожести
sudo pacman -S python-toml --noconfirm  # Библиотека Python для анализа и создания TOML
sudo pacman -S python-ujson --noconfirm  # Сверхбыстрый кодировщик и декодер JSON для Python
sudo pacman -S python-unidecode --noconfirm  # ASCII транслитерации текста Unicode
sudo pacman -S python-urllib3 --noconfirm  # Библиотека HTTP с потокобезопасным пулом соединений и поддержкой публикации файлов
sudo pacman -S python-webencodings --noconfirm  # Это Python-реализация стандарта кодирования WHATWG
sudo pacman -S python-websockets --noconfirm  # Реализация протокола WebSocket на Python (RFC 6455)
sudo pacman -S python-websocket-client --noconfirm  # Клиентская библиотека WebSocket для Python
sudo pacman -S python-xapp --noconfirm  # Библиотека Python Xapp
sudo pacman -S python-yaml --noconfirm  # Привязки Python для YAML с использованием быстрой библиотеки libYAML
sudo pacman -S python-zope-event --noconfirm  # Предоставляет простую систему событий
sudo pacman -S python-zope-interface --noconfirm  # Интерфейсы Zope для Python 3.x
# sudo pacman -S  --noconfirm  # 
# sudo pacman -S  --noconfirm  # 
# sudo pacman -S  --noconfirm  # 
# sudo pacman -S --noconfirm --needed   # 
#############################



