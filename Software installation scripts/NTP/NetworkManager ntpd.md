NetworkManager
ntpd можно включать/выключать вместе со стартом сетевого соединения с помощью диспетчерских скриптов (https://wiki.archlinux.org/title/NetworkManager#Network_services_with_NetworkManager_dispatcher). Пакет networkmanager-dispatcher-ntpd AUR (https://aur.archlinux.org/packages/networkmanager-dispatcher-ntpd/) устанавливает скрипты, настроенные на запуск и остановку ntpd.service (https://wiki.archlinux.org/title/Network_Time_Protocol_daemon_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)#%D0%97%D0%B0%D0%BF%D1%83%D1%81%D0%BA_ntpd_%D0%BF%D1%80%D0%B8_%D0%B7%D0%B0%D0%B3%D1%80%D1%83%D0%B7%D0%BA%D0%B5_%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B) одновременно с соединением.

https://wiki.archlinux.org/title/NetworkManager#Network_services_with_NetworkManager_dispatcher

https://wiki.archlinux.org/title/Network_Time_Protocol_daemon_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)


Примеры диспетчерских
Автоматически установить часовой пояс
Создайте скрипт диспетчера NetworkManager и сделайте его исполняемым :

/etc/NetworkManager/dispatcher.d/09-timezone

#!/bin/sh
case "$2" in
    up)
        timedatectl set-timezone "$(curl --fail https://ipapi.co/timezone)"
    ;;
esac

Tip
Использование connectivity-changeвместо upможет предотвратить смену часового пояса при подключении к VPN с помощью таких клиентов, как OpenConnect .
Альтернативно, инструмент tzupdate AUR автоматически устанавливает часовой пояс на основе геолокации IP-адреса. Это сравнение наиболее популярных API для геолокации IP-адресов может быть полезно при выборе API для использования в рабочей среде.

Как избежать тайм-аута диспетчера
Если всё вышеперечисленное работает, то этот раздел неактуален. Однако существует общая проблема, связанная с запуском скриптов диспетчера, которые выполняются дольше. Изначально использовался внутренний тайм-аут всего в три секунды. Если вызванный скрипт не завершался вовремя, он завершался. Позже тайм-аут был увеличен примерно до 20 секунд (подробнее см. в Bugtracker ). Если тайм-аут всё ещё создаёт проблему, решением может быть использование файла-переноса , чтобы скрипт NetworkManager-dispatcher.serviceоставался активным после выхода:

/etc/systemd/system/NetworkManager-dispatcher.service.d/remain_after_exit.conf

[Service]
RemainAfterExit=yes

Теперь запустите и включите измененную NetworkManager-dispatcher service.

Предупреждение
Добавление этой RemainAfterExitстроки предотвратит закрытие диспетчера. К сожалению, диспетчер должен закрыться, прежде чем снова сможет запустить ваши скрипты. При этом диспетчер не будет заблокирован по тайм-ауту, но и не закроется, что означает, что скрипты будут запускаться только один раз за загрузку. Поэтому не добавляйте эту строку, если только тайм-аут не является явной причиной проблем.
