Монтаж Bluetooth-устройств Thunar
Инструкции ниже описывают способ использования различных файловых менеджеров с Blueman. Примеры в этом разделе основаны на Thunar . Если вы используете другой файловый менеджер, замените Thunar на название используемого вами файлового менеджера.

obex_thunar.sh
#!/bin/bash
[ ! -d ~/Bluetooth ] && mkdir ~/Bluetooth   
fusermount -u ~/Bluetooth
obexfs -b $1 ~/Bluetooth
thunar ~/Bluetooth

Теперь вам нужно переместить скрипт в подходящее место (например, /usr/local/bin). После этого отметьте его как исполняемый .

Последний шаг — изменить строку в значке Blueman в трее > Локальные службы > Передача > Дополнительно на obex_thunar.sh %d.

sudo chmod +x /usr/local/bin/obex_thunar.sh