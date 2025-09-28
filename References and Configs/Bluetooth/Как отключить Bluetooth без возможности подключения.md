Как отключить Bluetooth без возможности подключения

https://zalinux.ru/?p=6921

 Alexey  12.01.2022  0  Железо  Bluetooth, модули ядра

Как насовсем отключить Bluetooth в Linux
В этой заметке показано, как удалить блютус полностью, а также исключить любую возможность его подключить.

Начните с деактивации и удаления службы bluetooth.

Удалите из автозагрузки и остановите службу bluetooth:

sudo systemctl disable bluetooth

sudo systemctl stop bluetooth

Удалите пакет bluez.

В Debian и производных:

sudo apt remove bluez


В Arch Linux и производных:

sudo pacman -R bluez

Модуль ядра bluetooth включён в ядро, поэтому удаление пакетов вроде bluez и blueman задачу отключения Bluetooth может решить не в полной мере — если удалить указанные пакеты у нас не будет инструментов и графических апплетов для наблюдением за Bluetooth, но это не означает, что на уровне ядра не будет выполнятся подключение Bluetooth устройств (например, USB адаптера Bluetooth), либо периферийные устройства не будут сопрягаться.

Для отключения Bluetooth воспользуемся отключением модуля ядра, который описан в разделе «Запрет на включение модулей (https://hackware.ru/?p=12514#5)(чёрный список модулей)(https://hackware.ru/?p=12514#5)».

Смотрите также: Модули ядра Linux (https://hackware.ru/?p=12514)

Как можно убедиться, апплет blueman, а следовательно и Bluetooth работают.


Для отключения модуля bluetooth создайте файл /etc/modprobe.d/blacklist.conf:

sudo gedit /etc/modprobe.d/blacklist.conf

и копируйте в него следующее:

blacklist bluetooth

install bluetooth /bin/true

Чтобы изменения вступили в силу, перезагрузите компьютер.


Как отключить Bluetooth до следующей перезагрузки
Для временной выгрузки (выключения) модуля выполните команду:

sudo modprobe -r bluetooth

Вы можете столкнуться с ошибкой:

modprobe: FATAL: Module bluetooth is in use.

Если предыдущая команда завершилась неудачей, то попробуйте следующую альтернативу:

sudo rmmod bluetooth

Пример вывода:

rmmod: ERROR: Module bluetooth is in use by: btrtl btintel btbcm bnep btusb rfcomm

Как можно увидеть, программа опять завершилась неудачей, но зато вывела список модулей, которые используют модуль ядра bluetooth и, следовательно, из-за которых невозможно отключить bluetooth.

Попробуем выгрузить все эти модули:


sudo rmmod bluetooth btrtl btintel btbcm bnep btusb rfcomm
В моём случае выполнение команды несколько раз подряд выгрузило практически все модули и Bluetooth был отключён.

Отключённый таким образом Bluetooth будет вновь работать после перезагрузки.



