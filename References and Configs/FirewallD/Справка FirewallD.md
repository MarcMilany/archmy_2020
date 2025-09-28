############# Справка ##############
# FirewallD (firewalld) ArchWiki:
# https://wiki.archlinux.org/title/Firewalld
# Установка и настройка firewalld в Arch Linux:
# https://xakep.ru/2017/02/15/firewalld/
# https://www.linuxboost.com/how-to-configure-firewall-on-arch-linux/
# Справка: firewall-cmd --help
# Параметры firewall-cmd Смотрим статус:
# systemctl status firewalld
# firewall-cmd --state
# Чтобы установить зону по умолчанию как «публичную» и включить брандмауэр, выполните:
# sudo firewall-cmd --set-default-zone=public
# Чтобы открыть службу или порт в firewalld, используйте параметры --add-serviceили --add-port. Например, чтобы разрешить SSH, выполните:
# sudo firewall-cmd --zone=public --add-service=ssh --permanent
# Или, чтобы разрешить определенный порт, например порт 80 для HTTP, выполните:
# sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
# firewall-cmd --permanent --add-port=22/tcp
# Разрешим подключение к HTTP:
# firewall-cmd --add-service=http
# Для удаления порта из правил используется параметр --remove-port:
# firewall-cmd --remove-port=22/tcp
# Не забудьте перезагрузить брандмауэр после внесения изменений:
# sudo firewall-cmd --reload
# Чтобы проверить состояние firewalld и просмотреть текущие правила, используйте следующую команду:
# sudo firewall-cmd --list-all
# В FirewallD (firewalld) предусмотрен режим, позволяющий одной командой заблокировать все соединения:
# firewall-cmd --panic-on
# Для проверки, в каком режиме находится файрвол, есть специальный ключ:
# firewall-cmd --query-panic 
# Отключается panic mode:
# firewall-cmd --panic-off
# В firewalld необязательно знать, какой порт привязан к сервису, достаточно указать название сервиса. Все остальное утилита возьмет на себя.
#############################################