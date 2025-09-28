############# Справка Bluetooth ##############
# Bluetooth (Русский)
# https://wiki.archlinux.org/title/Bluetooth
# https://web.archive.org/web/20210301155545/https://wiki.archlinux.org/index.php/Blueman
# https://wiki.archlinux.org/index.php/Bluetooth_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# http://www.bluez.org/
# https://archlinux.org/packages/extra/x86_64/bluez/
# ArchWiki Blueman:
# https://wiki.archlinux.org/index.php/Blueman
# https://github.com/blueman-project/blueman
ЗАПУСК BLUETOOTHHCTL
Запустить команду блютуз:
  $ bluetoothctl
Включите Bluetooth:
  [bluetooth]$ power on
Установить агента:
  [bluetooth]$ agent on
  [bluetooth]$ default-agent
СКАНИРУЮЩИЕ УСТРОЙСТВА
  [bluetooth]$ scan on
найдите и выберите MAC-АДРЕС устройств, которые вы хотите подключить
ДОВЕРЯТЬ
С помощью этой строки мы можем запомнить устройство, даже если оно не подключено.
  [bluetooth]$ trust <Mac Address>
ПАРА
  [bluetooth]$ pair <Mac Address>
СОЕДИНЯТЬ
  [bluetooth]$ connect <Mac Address>
ЗАКРЫТЬ СКАНИРОВАНИЕ И ВЫХОДИТЬ
В конце выключите сканирование и выйдите:
  [bluetooth]$ scan off
  [bluetooth]$ exit
ПРИ ЗАПУСКЕ
Чтобы автоматически запускать его при запуске или
если не работает, попробуйте использовать:
  $ sudo vi /etc/bluetooth/main.conf
  $ sudo nano /etc/bluetooth/main.conf
И изменить комментарий:
  AutoEnable=true