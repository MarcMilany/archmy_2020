Возможны случаи, когда потребуется вручную изменить текст Exec=в файле .desktop для ~/.local/share/applications/явного вызова Firejail.

Совет
Перехватчик pacman можно использовать для запуска Firecfg при выполнении операций pacman :
/etc/pacman.d/hooks/firejail.hook

[Trigger]
Type = Path
Operation = Install
Operation = Upgrade
Operation = Remove
Target = usr/bin/*
Target = usr/local/bin/*
Target = usr/share/applications/*.desktop

[Action]
Description = Configure symlinks in /usr/local/bin based on firecfg.config...
When = PostTransaction
Depends = firejail
Exec = /bin/sh -c 'firecfg >/dev/null 2>&1'



[Курок]
Тип = Путь
Операция = Установка
Операция = Обновление
Операция = Удалить
Цель = usr/bin/*
Цель = usr/local/bin/*
Цель = usr/share/applications/*.desktop

[Действие]
Описание = Настройте символические ссылки в /usr/local/bin на основе firecfg.config...
Когда = ПослеТранзакции
Зависит от = пожарная тюрьма
Выполнение = /bin/sh -c 'firecfg >/dev/null 2>&1'
Чтобы вручную отобразить прикладное приложение, выполните:

# ln -s /usr/bin/firejail /usr/local/bin/ приложение
Примечание
/usr/local/binдолжен быть установлен перед /usr/binи /binв переменном окружении PATH .
Убедитесь, что это значение PATHизменено для правильного запуска окружения рабочего стола или оконного менеджера. Например, при запуске i3 с помощью .xinitrc убедитесь в правильности установки PATHв ~/.profile. При использовании менеджера входа в систему в файле /etc/ly/config.iniесть возможность задать путь вручную.
Для запуска символьной программы с пользовательскими настройками Firejail — просто добавьте префикс firejail , как показано в #Конфигурация .
Для демона вам нужно будет перезаписать файл systemd unit для этого демона, чтобы вызвать firejail, см. Редактирование файлов юнитов .
Символические ссылки на gzip и xz Блокируют возможность предварительной загрузки makepkglibfakeroot.so . См. BBS#230913 .