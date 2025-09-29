Настроить релиз
Фоны можно добавлять /usr/share/backgroundsи выбирать в представлении «Темы» (нижний правый угол представления «Настройка»).

Настройте логотип ОС внутри/usr/share/lightdm-webkit/themes/litarvan/img/os.xxxxxxxx.png

Установка
Арч Линукс (3.2.0)
pacman -S --needed lightdm-webkit2-greeter lightdm-webkit-theme-litarvan
Если это еще не сделано, отредактируйте /etc/lightdm/lightdm.confи настройте greeter-session=lightdm-webkit2-greeter.
Затем отредактируйте /etc/lightdm/lightdm-webkit2-greeter.conf и установите theme или webkit-theme на litarvan.
Руководство (3.2.0)
Установите lightdm-webkit2-greeter с помощью менеджера зависимостей, если вы еще этого не сделали.
Загрузите и распакуйте tar-файл в/usr/share/lightdm-webkit/themes/litarvan/
Редактировать /etc/lightdm/lightdm-webkit2-greeter.conf и установить theme на litarvan.