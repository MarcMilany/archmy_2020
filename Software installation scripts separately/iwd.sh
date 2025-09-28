#!/bin/bash
###
# umask 0022 # Определение окончательных прав доступа - Для суперпользователя (root) umask по умолчанию равна 0022
set -e # Эта команда остановит выполнение сценария после сбоя команды и будет отправлен код ошибки
# set -euxo pipefail  # прекращает выполнение скрипта, даже если одна из частей пайпа завершилась ошибкой
###
### Help and usage (--help or -h) (Справка)
### SHARED VARIABLES AND FUNCTIONS (ОБЩИЕ ПЕРЕМЕННЫЕ И ФУНКЦИИ)
### Shell color codes (Цветовые коды оболочки)
RED="\e[1;31m"; GREEN="\e[1;32m"; YELLOW="\e[1;33m"; GREY="\e[3;93m"
BLUE="\e[1;34m"; CYAN="\e[1;36m"; BOLD="\e[1;37m"; MAGENTA="\e[1;35m"; NC="\e[0m"
################
echo ""
echo -e "${GREEN}=> ${NC}If you are connecting to the Internet via WiFi, then you need to connect to your WiFi network"
### Если вы подключаетесь к интернет по WiFi, то нужно подключиться к вашей WiFi-сети.
echo " Then use the wifi-menu utility: wifi-menu interface name "
### Затем воспользуемся утилитой wifi-menu: wifi-menu имя_интерфейса
# iwconfig
# wifi-menu имя_интерфейса  # Введите имя_интерфейса wifi
echo ""
echo -e "${BLUE}:: ${NC}Install the iNet Wireless Daemon (iwd)"  # Установите беспроводной демон iNet (iwd)
### iNet Wireless Daemon (iwd) направлен на создание комплексного решения для подключения по Wi-Fi для устройств на базе Linux.
### iwd (Русский) - ArchWiki: https://wiki.archlinux.org/title/Iwd_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
### Если вы используете Wi-Fi на своём ПК, то используйте команды (обычно имя wlan0, если у вас другое, то указываем своё):
### iwctl [--опции] [команды]
pacman -S --noconfirm --needed iwd  # Интернет-беспроводной демон (в который и входит утилита iwctl); https://archlinux.org/packages/extra/x86_64/iwd/ ; https://git.kernel.org/cgit/network/wireless/iwd.git/ ; 2025-06-15 12:13 UTC
echo ""
echo -e "${BLUE}:: ${NC}Launching the daemon and entering interactive mode"  # Запуск демона и вход в интерактивный режим
### Убедитесь, что wpa_supplicant остановлен до запуска iwd
### Для SystemD:
# systemctl stop wpa_supplicant
# systemctl disable wpa_supplicant
systemctl start iwd.service  # Запускаем службу iwd.service
# systemctl enable iwd.service  # Добавление службы iwd.service в автозапуск
echo " Launching iwctl online "  # Запуск iwctl в интерактивном режиме
echo " Auto-completion works interactively by pressing the Tab key "
echo " To exit the interactive mode, use the keyboard shortcut Ctrl+d "  # Запуск iwctl в интерактивном режиме
### В интерактивном режиме работает автодополнение по нажатию клавиши Tab. Для выхода из интерактивного режима используется комбинация клавиш Ctrl+d.
# iwctl --help  # Вызов общей помощи
echo " You should see this output in the terminal: [iwd]# "  # Вы Должны увидеть такой вывод в терминале: [iwd]#
echo " This prompt means that you have successfully switched to interactive mode and can now directly enter various commands "
### Это приглашение означает, что вы успешно перешли в интерактивный режим и теперь можете напрямую вводить различные команды.
iwctl  # Запуск iwctl в интерактивном режиме ; Утилита iwctl позволяет пользователю управлять беспроводными подключениями, сетями и устройствами iwd, предоставляя простой и согласованный интерфейс.
### [iwd]# Теперь приглашение командной строки имеет следующий вид
# Для вывода помощи по командам iwctl и доступным опциям: [iwd]# help
# Для выхода из интерактивного режима утилиты: [iwd]# quit
echo ""
echo -e "${BLUE}:: ${NC}Connecting to the network — List of all Wi-Fi devices "  # Подключение к сети
#echo " The list of available wireless adapters in the system and their status "
#adapter list  # Список доступных беспроводных адаптеров в системе и их состояние
echo " List of available wifi devices and their status "  # Список доступных wifi устройств и их состояние
device list  # Вывод Список всех Wi-Fi устройств (доступных wifi устройств и их состояние)
#echo " List of available wifi networks and their status "
#station list  # Список доступных wifi сетей и их состояние
echo ""
### Укажите ваше устройство (например: wlan0)
read -p " Specify your device (for example: wlan0): " wlan  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo " Network scanning "  # Сканирование сетей
### Например Наше устройство: wlan0
station $wlan scan  # Суть команды: указать название станции (например, wlan0) и запустить сканирование доступных сетей.
echo " List of available wireless networks to connect to "  # Список доступных беспроводных сетей для подключения
station $wlan get-networks  # Команда station wlan0 get-networks в Linux выводит список доступных беспроводных сетей для подключения.
### Объяснение: команда начинается с station, затем следует имя станции (нужно заменить station на фактический интерфейс, например, wlan0) и get-networks — действие для отображения результатов предыдущего сканирования. Команда извлекает данные сетей, захваченные во время сканирования. *Если команда не находит сети, это может быть связано с тем, что адаптер не видит сетей. В таком случае нужно убедиться, что iwd активен, а адаптер поддерживается системой.
echo ""
echo " We select the network we need and Connect to it "  # Выбираем нужную нам сеть и Подключаемся к ней
echo " You will be asked to enter a password (passphrase) to connect "  # Вас попросят ввести пароль (кодовую фразу) для подключения
### Укажите название вашей сети (например: Sotiris)
read -p " Specify the name of your network (for example: Sotiris): " networkname  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
station $wlan connect $networkname # Подключаемся к сети и вводим пароль
echo ""
echo " Let's see the network connection status "  #
station $wlan show  # Вывод состояния подключения
### Для отключения от сети вводится следующая команда:
# station $wlan disconnect  # Отключение от сети
### Для выхода из интерактивного режима утилиты: [iwd]# quit
# quit
##################