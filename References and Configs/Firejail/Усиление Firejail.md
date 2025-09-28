Усиление Firejail
Риск безопасности, связанный с тем, что Firejail является исполняемым файлом SUID, может быть уменьшен путем добавления строки

force-nonewprivs yes
в /etc/firejail/firejail.config. Однако это может нарушить работу определенных приложений. На Arch Linux VirtualBox больше не запускается. С ядром linux-hardened затронуты также Wireshark и браузеры на базе Chromium.

Дополнительные меры защиты включают создание специальной группы firejail с добавлением пользователя в эту группу и изменение файлового режима для исполняемого файла firejail. Подробности см. на сайте здесь.

Создайте специальную firejailгруппу

Это эквивалентно трюку с /etc/firejail/firejail.users , описанному выше, но построенному с использованием примитивов файловой системы. Создайте группу Firejail , добавьте исполняемый файл /usr/bin/firejail в эту группу, измените режим доступа к файлу на 4750 и добавьте в группу только тех пользователей, которым разрешено использовать Firejail. Пример инструкций для Debian:

$ su
# addgroup firejail
# chown root:firejail /usr/bin/firejail
# chmod 4750 /usr/bin/firejail
# ls -l /usr/bin/firejail
-rwsr-x--- 1 root firejail 1584496 Apr 5 21:53 /usr/bin/firejail
 
Чтобы добавить пользователя в группу, введите:

# usermod -a -G firejail username
 
После добавления пользователя в группу необходимо выйти из системы и снова войти в систему.

 

Совет
вы можете добавить хук pacman для автоматической смены владельца и режима firejail:
/etc/pacman.d/hooks/firejail-permissions.hook

[Trigger]
Operation = Install
Operation = Upgrade
Type = Package
Target = firejail
[Action]
Depends = coreutils
Depends = bash
When = PostTransaction
Exec = /usr/bin/sh -c "chown root:firejail /usr/bin/firejail && chmod 4750 /usr/bin/firejail"
Description = Setting /usr/bin/firejail owner to "root:firejail" and mode "4750"
Обязательно создайте группу firejail и добавьте в нее своего пользователя.