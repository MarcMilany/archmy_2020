Если вы используете окружение KDE и столкнулись с проблемой тиринга, нужно открыть окно настроек (Display and Monitor -> Compositor) и задать опцию

Tearing prevention “vsync”: Full screen repaints.

Параметр tearing prevention vsync в linux

Если в KDE используется оконный менеджер KDE, нужно создать файл:

$ sudo nano /etc/profile.d/kwin.sh

и добавить в него строку:

export KWIN_TRIPLE_BUFFER=1
Также можно отредактировать файл оконного менеджера KWin:

$ sudo nano /home/sysops/.config/kwinrc

В секции [Compositing] добавьте строки:

MaxFPS = 200
RefreshRate = 200