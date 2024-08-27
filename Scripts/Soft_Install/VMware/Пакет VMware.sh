#!/bin/bash
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 

службы systemd
(Необязательно) Вместо использования /etc/init.d/vmware ( start|stop|status|restart) и /usr/bin/vmware-usbarbitrator непосредственно для управления службами вы также можете использовать .service файлы ( vmware-usbarbitrator и vmware-networks также включены в vmware-workstation AUR с некоторыми отличиями):

/etc/systemd/system/vmware.service

[Unit]
Description=VMware daemon
Requires=vmware-usbarbitrator.service
Before=vmware-usbarbitrator.service
After=network.target

[Service]
ExecStart=/etc/init.d/vmware start
ExecStop=/etc/init.d/vmware stop
PIDFile=/var/lock/subsys/vmware
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target

##############################
/etc/systemd/system/vmware-usbarbitrator.service


[Unit]
Description=VMware USB Arbitrator
Requires=vmware.service
After=vmware.service

[Service]
ExecStart=/usr/bin/vmware-usbarbitrator
ExecStop=/usr/bin/vmware-usbarbitrator --kill
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target

#####################################

Добавьте эту службу для включения сетевого взаимодействия:
# Add this service to enable networking:

/etc/systemd/system/vmware-networks-server.service


[Unit]
Description=VMware Networks
Wants=vmware-networks-configuration.service
After=vmware-networks-configuration.service

[Service]
Type=forking
ExecStartPre=-/sbin/modprobe vmnet
ExecStart=/usr/bin/vmware-networks --start
ExecStop=/usr/bin/vmware-networks --stop

[Install]
WantedBy=multi-user.target



Добавьте также эту службу, если вы хотите подключиться к своей установке VMware Workstation с другой консоли сервера Workstation:
# Add this service as well, if you want to connect to your VMware Workstation installation from another Workstation Server Console:

/etc/systemd/system/vmware-workstation-server.service


[Unit]
Description=VMware Workstation Server
Requires=vmware.service
After=vmware.service

[Service]
ExecStart=/etc/init.d/vmware-workstation-server start
ExecStop=/etc/init.d/vmware-workstation-server stop
PIDFile=/var/lock/subsys/vmware-workstation-server
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target

############################

После этого вы сможете включить их при загрузке.
After which you can enable them on boot.

##############################

Служба сервера рабочей станции
# Workstation Server service
Вызовы в его цепочке команд, несмотря на то vmware-workstation-server.service, wssc-adminTool что были переименованы в vmware-wssc-adminTool.
# The vmware-workstation-server.service calls wssc-adminTool in its command chain, despite having been renamed to vmware-wssc-adminTool.

Чтобы предотвратить запуск службы, это можно исправить с помощью символической ссылки:
# To prevent the service startup, this can be fixed with a symlink:

# ln -s wssc-adminTool /usr/lib/vmware/bin/vmware-wssc-adminTool

Запуск приложения

Чтобы открыть VMware Workstation Pro:

$ vmware

или Player:

$ vmplayer


Приостановка виртуальных машин перед приостановкой/переходом хоста в спящий режим
Создайте исполняемый файл:

/usr/lib/systemd/system-sleep/vmware_suspend_all.sh

####################################

#!/bin/bash

set -eu

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <period> <action>"
    exit 1
fi

period=$1
action=$2

echo "vmware system-sleep hook argv: ${period} ${action}"

if ! command -v vmrun &>/dev/null; then
    echo "command not found: vmrun"
fi

if [[ "${period}" = "pre" ]]; then
    readarray -t vms < <(vmrun list | tail -n +2)

    echo "Number of running VMs: ${#vms[@]}"

    if [[ ${#vms[@]} -eq 0 ]]; then
        exit
    fi

    for vm in "${vms[@]}"; do
        echo -n "Suspending ${vm}... "
        vmrun suspend "${vm}"
        echo "done"
    done

    sleep 1
else
    echo "Nothing to do"
fi

############################



