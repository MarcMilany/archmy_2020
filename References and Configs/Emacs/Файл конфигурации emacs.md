Файл конфигурации .emacs

После того, как Вы успешно установили GNU Emacs на свой компьютер, необходимо создать файл с названием .emacs и уже в нем прописать основные настройки.
Обозначения, используемые в статье (повторение — мать учения):

C-a: Ctrl-a;
M-a: Meta-a (Если у Вас нет клавиши Meta (Alt), используете клавишу Esc);
C-M-a: Ctrl-Meta-a.

Итак, запускаем Emacs. С помощью комбинации клавиш C-x C-f создаем новый файл .emacs и начинаем в нем писать. Не обижайтесь, но вдаваться в синтаксис языка elisp не стану — это превратит статью в монстра. В конце просто приведу ссылки на необходимые ресурсы.

Для начала, расскажем Emacs о том, в какой операционной системе он запустился. Для этого напишем на elisp две функции, которые нам в этом помогут:

;; System-type definition
(defun system-is-linux()
    (string-equal system-type "gnu/linux"))
(defun system-is-windows()
    (string-equal system-type "windows-nt"))

Теперь, вызывая эти функции как условия для операторов ветвления, мы можем настроить кроссплатформенный файл конфигурации для Emacs (результатом наших трудов будет файл .emacs, который прекрасно работает в ОС MS Windows и дистрибутивах GNU/Linux. На Mac OS X не проверял).

IDE для Common Lisp

Для превращения Emacs в полноценную среду разработки для языка Common Lisp нам понадобится два пакета:

реализация Common Lisp. Я выбрал SBCL;
Slime — режим Emacs для разработки приложений на языке Common Lisp.

Если Вы пользователь ОС MS Windows и, вдруг, пишете на Common Lisp, то Вам нужно:

скачать SBCL;
установить в C:\sbcl\ скаченный SBCL;
скачать Slime;
разместить в C:\slime\ скаченный Slime.

На GNU/Linux все проще: выполнить из командной строки:

sudo aptitude install slime sbcl

Поехали дальше

Если Вы счастливый пользователь Mac OS X или дистрибутива GNU/Linux, то Emacs полезно запустить как сервер:

;; Start Emacs as a server
(when (system-is-linux)
    (require 'server)
    (unless (server-running-p)
        (server-start))) ;; запустить Emacs как сервер, если ОС - GNU/Linux

Далее, укажем Emacs пути по которым но сможет найти установленные дополнения (в частности, пакеты Slime и SBCL):

;; MS Windows path-variable
(when (system-is-windows)
    (setq win-sbcl-exe          "C:/sbcl/sbcl.exe")
    (setq win-init-path         "C:/.emacs.d")
    (setq win-init-ct-path      "C:/.emacs.d/plugins/color-theme")
    (setq win-init-ac-path      "C:/.emacs.d/plugins/auto-complete")
    (setq win-init-slime-path   "C:/slime")
    (setq win-init-ac-dict-path "C:/.emacs.d/plugins/auto-complete/dict"))

;; Unix path-variable
(when (system-is-linux)
    (setq unix-sbcl-bin          "/usr/bin/sbcl")
    (setq unix-init-path         "~/.emacs.d")
    (setq unix-init-ct-path      "~/.emacs.d/plugins/color-theme")
    (setq unix-init-ac-path      "~/.emacs.d/plugins/auto-complete")
    (setq unix-init-slime-path   "/usr/share/common-lisp/source/slime/")
    (setq unix-init-ac-dict-path "~/.emacs.d/plugins/auto-complete/dict"))

Давайте расскажем Emacs о том, кто мы такие (мало-ли, решите через Emacs почту отправлять или в jabber'e переписываться...):

;; My name and e-mail adress
(setq user-full-name   "%user-name%")
(setq user-mail-adress "%user-mail%")

Мой любимый dired-mode. Настроим его:

;; Dired
(require 'dired)
(setq dired-recursive-deletes 'top) ;; чтобы можно было непустые директории удалять...

Теперь можно запустить dired-mode комбинацией клавиш C-x d. Для удаления папки в dired-mode наведите курсор на эту папку, нажмите d, затем x. Чтобы убрать с папки отметку на удаление нажмите u.

Замечательный способ «прыгать» по определениям функций почти для всех языков программирования — Imenu. Предположим, что у Вас файл с программой на 100500 строк с кучей функций. Не беда! Нажимаем F6 и в минибуфере вводим часть имени искомой функции и TAB'ом дополняем. Нажали Enter — и мы на определении искомой функции:

;; Imenu
(require 'imenu)
(setq imenu-auto-rescan      t) ;; автоматически обновлять список функций в буфере
(setq imenu-use-popup-menu nil) ;; диалоги Imenu только в минибуфере
(global-set-key (kbd "<f6>") 'imenu) ;; вызов Imenu на F6

Пишем название открытого буфера в шапке окна:

;; Display the name of the current buffer in the title bar
(setq frame-title-format "GNU Emacs: %b")

Помните, что мы определили пути, по которым Emacs ищет дополнения и внешние программы? Пусть «пройдется» по этим путям (где дополнения) при запуске:

;; Load path for plugins
(if (system-is-windows)
    (add-to-list 'load-path win-init-path)
    (add-to-list 'load-path unix-init-path))

Еще не забыли, что Emacs предоставляет Вам прекрасную среду для plain/text заметок (organizer), ведения справочной информации, управления проектами, организации базы знаний и т.д. — org-mode? Настроим:

;; Org-mode settings
(require 'org) ;; Вызвать org-mode
(global-set-key "\C-ca" 'org-agenda) ;; поределение клавиатурных комбинаций для внутренних
(global-set-key "\C-cb" 'org-iswitchb) ;; подрежимов org-mode
(global-set-key "\C-cl" 'org-store-link)
(add-to-list 'auto-mode-alist '("\\.org$" . Org-mode)) ;; ассоциируем *.org файлы с org-mode

Наведем аскетизм красоту — уберем экраны приветствия при запуске:

;; Inhibit startup/splash screen
(setq inhibit-splash-screen   t)
(setq ingibit-startup-message t) ;; экран приветствия можно вызвать комбинацией C-h C-a

Выделим выражения между {},[],(), когда курсор находится на одной из скобок — полезно для программистов:

;; Show-paren-mode settings
(show-paren-mode t) ;; включить выделение выражений между {},[],()
(setq show-paren-style 'expression) ;; выделить цветом выражения между {},[],()

В новых версиях Emacs внедрили electic-mod'ы. Первый из них автоматически расставляет отступы (работает из рук вон плохо), второй — закрывает скобки, кавычки и т.д. Отключим первый (Python программисты меня поймут...) и включим второй:

;; Electric-modes settings
(electric-pair-mode    1) ;; автозакрытие {},[],() с переводом курсора внутрь скобок
(electric-indent-mode -1) ;; отключить индентацию  electric-indent-mod'ом (default in Emacs-24.4)

Хотим иметь возможность удалить выделенный текст при вводе поверх? Пожалуйста:

;; Delete selection
(delete-selection-mode t)

Уберем лишнее: всякие меню, scroll-bar'ы, tool-bar'ы и т.п.:

;; Disable GUI components
(tooltip-mode      -1)
(menu-bar-mode     -1) ;; отключаем графическое меню
(tool-bar-mode     -1) ;; отключаем tool-bar
(scroll-bar-mode   -1) ;; отключаем полосу прокрутки
(blink-cursor-mode -1) ;; курсор не мигает
(setq use-dialog-box     nil) ;; никаких графических диалогов и окон - все через минибуфер
(setq redisplay-dont-pause t)  ;; лучшая отрисовка буфера
(setq ring-bell-function 'ignore) ;; отключить звуковой сигнал

Никаких автоматических сохранений и резервных копий! Только hardcore:

;; Disable backup/autosave files
(setq make-backup-files        nil)
(setq auto-save-default        nil)
(setq auto-save-list-file-name nil) ;; я так привык... хотите включить - замените nil на t

Самое больное и сложное место в настройке — кодировки:

;; Coding-system settings
(set-language-environment 'UTF-8)
(if (system-is-linux) ;; для GNU/Linux кодировка utf-8, для MS Windows - windows-1251
    (progn
        (setq default-buffer-file-coding-system 'utf-8)
        (setq-default coding-system-for-read    'utf-8)
        (setq file-name-coding-system           'utf-8)
        (set-selection-coding-system            'utf-8)
        (set-keyboard-coding-system        'utf-8-unix)
        (set-terminal-coding-system             'utf-8)
        (prefer-coding-system                   'utf-8))
    (progn
        (prefer-coding-system                   'windows-1251)
        (set-terminal-coding-system             'windows-1251)
        (set-keyboard-coding-system        'windows-1251-unix)
        (set-selection-coding-system            'windows-1251)
        (setq file-name-coding-system           'windows-1251)
        (setq-default coding-system-for-read    'windows-1251)
        (setq default-buffer-file-coding-system 'windows-1251)))

Включаем нумерацию строк:

;; Linum plugin
(require 'linum) ;; вызвать Linum
(line-number-mode   t) ;; показать номер строки в mode-line
(global-linum-mode  t) ;; показывать номера строк во всех буферах
(column-number-mode t) ;; показать номер столбца в mode-line
(setq linum-format " %d") ;; задаем формат нумерации строк

Продолжаем наводить красоту:

;; Fringe settings
(fringe-mode '(8 . 0)) ;; органичиталь текста только слева
(setq-default indicate-empty-lines t) ;; отсутствие строки выделить глифами рядом с полосой с номером строки
(setq-default indicate-buffer-boundaries 'left) ;; индикация только слева

;; Display file size/time in mode-line
(setq display-time-24hr-format t) ;; 24-часовой временной формат в mode-line
(display-time-mode             t) ;; показывать часы в mode-line
(size-indication-mode          t) ;; размер файла в %-ах

Автоматический перенос длинных строк:

;; Line wrapping
(setq word-wrap          t) ;; переносить по словам
(global-visual-line-mode t)

Определим размер окна с Emacs при запуске:

;; Start window size
(when (window-system)
    (set-frame-size (selected-frame) 100 50))

Интерактивный поиск и открытие файлов? Пожалуйста:

;; IDO plugin
(require 'ido)
(ido-mode                      t)
(icomplete-mode                t)
(ido-everywhere                t)
(setq ido-vitrual-buffers      t)
(setq ido-enable-flex-matching t)

Быстрая навигация между открытыми буферами:

;; Buffer Selection and ibuffer settings
(require 'bs)
(require 'ibuffer)
(defalias 'list-buffers 'ibuffer) ;; отдельный список буферов при нажатии C-x C-b
(global-set-key (kbd "<f2>") 'bs-show) ;; запуск buffer selection кнопкой F2


Цветовые схемы. Как без них? Для этого:

скачаем пакет color-theme для Emacs отсюда;
создадим директории .emacs.d/plugins/color-theme;
распакуем туда содержимое архива с темами;
расположить папку .emacs.d в:
для MS Windows в корень диска C:\.emacs.d
для GNU/Linux в домашнюю директорию ~/.emacs.d
запишем в наш .emacs следующие строки:

;; Color-theme definition <http://www.emacswiki.org/emacs/ColorTheme>
(defun color-theme-init()
    (require 'color-theme)
    (color-theme-initialize)
    (setq color-theme-is-global t)
    (color-theme-charcoal-black))
(if (system-is-windows)
    (when (file-directory-p win-init-ct-path)
        (add-to-list 'load-path win-init-ct-path)
        (color-theme-init))
    (when (file-directory-p unix-init-ct-path)
        (add-to-list 'load-path unix-init-ct-path)
        (color-theme-init)))

Подсветка кода:

;; Syntax highlighting
(require 'font-lock)
(global-font-lock-mode             t) ;; включено с версии Emacs-22. На всякий...
(setq font-lock-maximum-decoration t)

Настройки отступов:

;; Indent settings
(setq-default indent-tabs-mode nil) ;; отключить возможность ставить отступы TAB'ом
(setq-default tab-width          4) ;; ширина табуляции - 4 пробельных символа
(setq-default c-basic-offset     4)
(setq-default standart-indent    4) ;; стандартная ширина отступа - 4 пробельных символа
(setq-default lisp-body-indent   4) ;; сдвигать Lisp-выражения на 4 пробельных символа
(global-set-key (kbd "RET") 'newline-and-indent) ;; при нажатии Enter перевести каретку и сделать отступ
(setq lisp-indent-function  'common-lisp-indent-function)

Плавный скроллинг:

;; Scrolling settings
(setq scroll-step               1) ;; вверх-вниз по 1 строке
(setq scroll-margin            10) ;; сдвигать буфер верх/вниз когда курсор в 10 шагах от верхней/нижней границы  
(setq scroll-conservatively 10000)

Укоротить сообщения в минибуфере:

;; Short messages
(defalias 'yes-or-no-p 'y-or-n-p)

Общий с ОС буфер обмена:

;; Clipboard settings
(setq x-select-enable-clipboard t)

Настройки пустых строк в конце буфера:

;; End of file newlines
(setq require-final-newline    t) ;; добавить новую пустую строку в конец файла при сохранении
(setq next-line-add-newlines nil) ;; не добавлять новую строку в конец при смещении 
                                    ;; курсора  стрелками

Выделять результаты поиска:

;; Highlight search resaults
(setq search-highlight        t)
(setq query-replace-highlight t)

Перемещение между сплитами при помощи комбинаций M-arrow-keys (кроме org-mode):

;; Easy transition between buffers: M-arrow-keys
(if (equal nil (equal major-mode 'org-mode))
    (windmove-default-keybindings 'meta))

Удалить лишние пробелы в конце строк, заменить TAB'ы на пробелы и выровнять отступы при сохранении буфера в файл, автоматически:

;; Delete trailing whitespaces, format buffer and untabify when save buffer
(defun format-current-buffer()
    (indent-region (point-min) (point-max)))
(defun untabify-current-buffer()
    (if (not indent-tabs-mode)
        (untabify (point-min) (point-max)))
    nil)
(add-to-list 'write-file-functions 'format-current-buffer)
(add-to-list 'write-file-functions 'untabify-current-buffer)
(add-to-list 'write-file-functions 'delete-trailing-whitespace)

Пакет CEDET — работа с C/C++/Java (прекрасная статья Alex Ott'a по CEDET):

;; CEDET settings
(require 'cedet) ;; использую "вшитую" версию CEDET. Мне хватает...
(add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-highlight-func-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-show-parser-state-mode)
(semantic-mode   t)
(global-ede-mode t)
(require 'ede/generic)
(require 'semantic/ia)
(ede-enable-generic-projects)

Автодополнение ввода. Для этого:

скачаем пакет auto-complete для Emacs отсюда;
создадим директории .emacs.d/plugins/auto-complete;
распакуем туда содержимое архива с auto-complete;
расположить папку .emacs.d в:
для MS Windows в корень диска C:\.emacs.d
для GNU/Linux в домашнюю директорию ~/.emacs.d
запишем в наш .emacs следующие строки:

;; Auto-complete plugin <http://www.emacswiki.org/emacs/AutoComplete>
(defun ac-init()
    (require 'auto-complete-config)
    (ac-config-default)
    (if (system-is-windows)
        (add-to-list 'ac-dictionary-directories win-init-ac-dict-path)
        (add-to-list 'ac-dictionary-directories unix-init-ac-dict-path))
    (setq ac-auto-start        t)
    (setq ac-auto-show-menu    t)
    (global-auto-complete-mode t)
    (add-to-list 'ac-modes   'lisp-mode)
    (add-to-list 'ac-sources 'ac-source-semantic) ;; искать автодополнения в CEDET
    (add-to-list 'ac-sources 'ac-source-variables) ;; среди переменных
    (add-to-list 'ac-sources 'ac-source-functions) ;; в названиях функций
    (add-to-list 'ac-sources 'ac-source-dictionary) ;; в той папке где редактируемый буфер
    (add-to-list 'ac-sources 'ac-source-words-in-all-buffer) ;; по всему буферу
    (add-to-list 'ac-sources 'ac-source-files-in-current-dir))
(if (system-is-windows)
    (when (file-directory-p win-init-ac-path)
        (add-to-list 'load-path win-init-ac-path)
        (ac-init))
    (when (file-directory-p unix-init-ac-path)
        (add-to-list 'load-path unix-init-ac-path)
        (ac-init)))

Настроим среду для Common Lisp — Slime:

;; SLIME settings
(defun run-slime()
    (require 'slime)
    (require 'slime-autoloads)
    (setq slime-net-coding-system 'utf-8-unix)
    (slime-setup '(slime-fancy slime-asdf slime-indentation))) ;; загрузить основные дополнения Slime
;;;; for MS Windows
(when (system-is-windows)
    (when (and (file-exists-p win-sbcl-exe) (file-directory-p win-init-slime-path))
        (setq inferior-lisp-program win-sbcl-exe)
        (add-to-list 'load-path win-init-slime-path)
        (run-slime)))
;;;; for GNU/Linux
(when (system-is-linux)
    (when (and (file-exists-p unix-sbcl-bin) (file-directory-p unix-init-slime-path))
        (setq inferior-lisp-program unix-sbcl-bin)
        (add-to-list 'load-path unix-init-slime-path)
        (run-slime)))

Настроим Bookmark — закладки, которые помогают быстро перемещаться по тексту:

;; Bookmark settings
(require 'bookmark)
(setq bookmark-save-flag t) ;; автоматически сохранять закладки в файл
(when (file-exists-p (concat user-emacs-directory "bookmarks"))
    (bookmark-load bookmark-default-file t)) ;; попытаться найти и открыть файл с закладками
(global-set-key (kbd "<f3>") 'bookmark-set) ;; создать закладку по F3 
(global-set-key (kbd "<f4>") 'bookmark-jump) ;; прыгнуть на закладку по F4
(global-set-key (kbd "<f5>") 'bookmark-bmenu-list) ;; открыть список закладок
(setq bookmark-default-file (concat user-emacs-directory "bookmarks")) ;; хранить закладки в файл bookmarks в .emacs.d

Собственно, всё! Можно нажать C-x C-s и сохранить файл .emacs. Куда положить файл .emacs и папку .emacs.d (если использовать пути из моего .emacs):

MS Windows:

.emacs в C:\Users\%username%\AppData\Roaming\
папку .emacs.d в корень диска C:\

GNU/Linux:

.emacs в домашнюю директорию: /home/%username%/
папку .emacs.d в домашнюю директорию: /home/%username%/

Мой .emacs можно скачать с моей странички на GitHub.
