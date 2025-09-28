############# —правка по htop iotop  ##############
ќсновные параметры htop
ѕри запуске htop можно использовать различные опции:
-d Чdelay Ц устанавливает задержку обновлени€ данных (в дес€тых дол€х секунды)
-C Чno-color Ц отключает цветовое отображение
-h Чhelp Ц выводит справку по команде
-u Чuser=пользователь Ц показывает процессы только определенного пользовател€
-p Чpid=PID` Ц выводит информацию о процессах с заданными PID
-s Чsort-key COLUMN Ц сортирует процессы по указанному столбцу
-v Чversion Ц выводит текущую версию программы
ѕроверить версию htop можно с помощью команды:
htop --version
”правление процессами в htop:
htop позвол€ет интерактивно управл€ть процессами с помощью гор€чих клавиш:
—трелки, PageUp, PageDown, Home, End Ц перемещение по списку процессов
ѕробел Ц отметить/сн€ть отметку с процесса
U Ц сн€ть все отметки с процессов
s Ц трассировка системных вызовов процесса (требует strace)
F1 Ц вызов справки
F2 Ц настройки программы
F3 Ц поиск процессов
F4 Ц фильтраци€ процессов
F5 Ц отображение процессов в виде дерева зависимостей
Htop и многое другое на пальцах (https://habr.com/ru/articles/316806/ ; https://ioflood.com/blog/htop-linux-command/)

#############################

ќсновные параметры iotop
ѕараметры
-v, --version          show program's version number and exit
-h, --help             show this help message and exit
-H, --help-type=TYPE   set type of interactive help (none, win or inline)
-o, --only             only show processes or threads actually doing I/O
    --no-only          show all processes or threads
-b, --batch            non-interactive mode
-n NUM, --iter=NUM     number of iterations before ending [infinite]
-d SEC, --delay=SEC    delay between iterations [1 second]
-p PID, --pid=PID      processes/threads to monitor [all]
-u USER, --user=USER   users to monitor [all]
-P, --processes        only show processes, not all threads
    --threads          show all threads
-a, --accumulated      show accumulated I/O instead of bandwidth
    --no-accumulated   show bandwidth
-A, --accum-bw         show accumulated bandwidth
    --no-accum-bw      show last iteration bandwidth
-k, --kilobytes        use kilobytes instead of a human friendly unit
    --no-kilobytes     use human friendly unit
-t, --time             add a timestamp on each line (implies --batch)
-c, --fullcmdline      show full command line
    --no-fullcmdline   show program names only
-1, --hide-pid         hide PID/TID column
    --show-pid         show PID/TID column
-2, --hide-prio        hide PRIO column
    --show-prio        show PRIO column
-3, --hide-user        hide USER column
    --show-user        show USER column
-4, --hide-read        hide DISK READ column
    --show-read        show DISK READ column
-5, --hide-write       hide DISK WRITE column
    --show-write       show DISK WRITE column
-6, --hide-swapin      hide SWAPIN column
    --show-swapin      show SWAPIN column
-7, --hide-io          hide IO column
    --show-io          show IO column
-8, --hide-graph       hide GRAPH column
    --show-graph       show GRAPH column
-9, --hide-command     hide COMMAND column
    --show-command     show COMMAND column
-g TYPE, --grtype=TYPE set graph data source (io, r, w, rw and sw)
-R, --reverse-graph    reverse GRAPH column direction
    --no-reverse-graph do not reverse GRAPH column direction
-q, --quiet            print column names only on the first run (implies --batch)
                       a second -q will also suppress the first run column names
                       a third -q will suppress the I/O summary
-x, --dead-x           show exited processes/threads with letter x
    --no-dead-x        show exited processes/threads with background
-e, --hide-exited      hide exited processes
    --show-exited      show exited processes
-l, --no-color         do not colorize values
    --color            colorize values
-T, --hide-time        hide current time
    --show-time        show current time
    --si               use SI units of 1000 when printing values
    --no-si            use non-SI units of 1024 when printing values
    --threshold=1..10  threshold to switch to next unit
    --ascii            disable using Unicode
    --unicode          use Unicode drawing chars
-N, --inverse          use inverse interface (black on white)
    --filter=REGEX     filter processes by TID and COMMAND
-W, --write            write preceding options to the config and exit


#############################

–уководство NVTOP и параметры командной строки
NVTOP поставл€етс€ с man-страницей!

man nvtop
ƒл€ быстрой помощи по аргументам командной строки

nvtop -h
nvtop --help

—охранение настроек
¬ы можете сохранить настройки, заданные в окне настройки, нажав F12. Ќастройки будут загружены при следующем запуске nvtop.

#############################



