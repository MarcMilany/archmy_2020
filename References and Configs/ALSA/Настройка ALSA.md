############# Справка ##############
### ArchWiki ALSA:
# https://wiki.archlinux.org/title/Advanced_Linux_Sound_Architecture
# https://wiki.archlinux.org/title/Timidity%2B%2B
# https://www.alsa-project.org/
# https://www.alsa-project.org/wiki/Documentation
# https://archlinux.org/packages/extra/x86_64/alsa-utils/
# ARU - Руководство по оптимизации Arch Linux
# https://ventureo.codeberg.page/v2022.02.28/source/generic-system-acceleration.html#pulseaudio
### Настройка ALSA:
# Настройка звука в Linux - качество и низкая задержка в DAW
# https://dtf.ru/software/3272607-nastroika-zvuka-v-linux-kachestvo-i-nizkaya-zaderzhka-v-daw
# Agatha: https://technogothic.net/pages/WineasioSetup/
# Video: https://www.youtube.com/watch?v=6RrkLw220PY
# https://vkvideo.ru/video440481718_456239062
# Быстрая настройка звука obs на linux линукс. Настройка Jack ubuntu. QJackctl. Jack setup.
# https://www.youtube.com/watch?v=9dYqjvlFRoc
### Теперь перейдём к небольшой (необходимой) настроке нашего (вашего) Клиента ALSA:
### 1. Добавление пользователя в группы (realtime,audio,disk) было выполнено сценарием скрипта,
# (ЕСЛИ, ВДРУГ этого не произошло) Чтобы увидеть, к каким группам принадлежит текущий пользователь:
# Вот команда ввода: groups или groups root
# Теперь вы можете убедится, что пользователь был добавлен в группы /etc/group audio realtime disk
# Проверим наличие группы с помощью команды "cat /etc/group | grep имя_группы
# sudo cat /etc/group | grep audio
# sudo cat /etc/group | grep realtime
# sudo cat /etc/group | grep disk
# На Всякий (пожарный) случай:
# Добавление групп: sudo addgroup [параметры] имя_группы
# Все созданные группы хранятся в файле /etc/group
# groupadd [options] GROUP ; В качестве обязательного параметра - GROUP ей передается имя группы.
# И также могут быть переданы необязательные параметры, из которых можно выделить следующие:
# -g, --gid GID: устанавливает GID для новой группы
# -p, --password ПАРОЛЬ: применяет пароль для новой группы
# -U, --users ПОЛЬЗОВАТЕЛИ: задает список пользователей-членов этой группы
# sudo groupadd audio
# sudo groupadd realtime
# sudo groupadd disk
### Добавление пользователя в группу (realtime,audio,disk)
### - sudo usermod -aG realtime,audio,disk [имя пользователя без скобок] - включаем себя в нужные группы
### usermod -a -G realtime,audio,disk username  # Чтобы добавить пользователя в группу
# sudo usermod -a -G realtime,audio,disk $USER
# sudo usermod -aG realtime,audio,disk $USER  # realtime group, добавление пользователя в realtime группу
# *Будьте осторожны с пакетом realtime-privileges , она дает задержку (но мной этого не замечо)
# ?sudo pacman -Rcns realtime-privileges  # Удалить пакет "realtime-privileges"
# Ещё разок Проверим наличие группы с помощью команды "cat /etc/group | grep имя_группы
### 2. Обязательно посмотрите создался ли файл в /etc/security/limits.conf
# Для дальнейшего внесения изменения в файл limits.conf
# Думаю (вернее знаю), что после установки ALSA и перезагрузки системы файл limits.conf должен уже быть!
# sudo ls -l /etc/security/limits.conf  # ls — выводит список папок и файлов в текущей директории
# Если создан едем дальше: перейдите к пункту создания бэкапа этого файла
# Если НЕ создан, ДАВАЙТЕ создадим:
# sudo touch /etc/security/limits.conf   # Создать файл в /etc/security/limits.conf
# Для начала сделаем его бэкап /etc/security/limits.conf
# sudo cp /etc/security/limits.conf  /etc/security/limits.conf.back
# sudo cp -v /etc/security/limits.conf  /etc/security/limits.conf.back  # Для начала сделаем его бэкап
# sudo cp -v /etc/security/limits.conf  /etc/security/limits.conf.original  # -v или --verbose -Выводить информацию о каждом файле, который обрабатывает команда cp.
### 3. Далее добавляем две строки в /etc/security/limits.conf:
# *Если в файле есть записи (данные) добавить в конце (внизу) файла!
# ?@audio - rtprio 90
# @audio - rtprio 95
# @audio - memlock unlimited
# Параметры для audio - rtprio 90 или 95 - Тум всё зависит от многих слогаемых (железа и т.д.)
# Также можно создать файл в /etc/security/limits.d/audio.conf - у меня он создан, а вы выбирайте сами Надо или Нет !
# Создаём файл /etc/security/limits.d/audio.conf со следующим содержимым:
# ?@audio - rtprio 95
# @audio - rtprio 90
# @audio - memlock unlimited
# Параметры для audio - rtprio 90 или 95 - Тум всё зависит от многих слогаемых (железа и т.д.)
# Потом нужно перелогиниться в системе, а лучше - перезагрузиться.
# *Примечание! НЕкоторые пользователи предлогают пойти ещё дальше и внести изменения в etc/default/grub
# И Допустим ИЗМЕНИТЬ один параметр ядра threadirqs (threadirqs) например:
# БЫЛО: GRUB_CMDLINE_LINUX_DEFAULT="guiet resume=UUID=89632de7-2ff9-4b4e-a099-93b8547df254"
# СТАЛО: GRUB_CMDLINE_LINUX_DEFAULT="guiet threadirqs resume=UUID=89632de7-2ff9-4b4e-a099-93b8547df254"
# ЧТОБЫ не править файл самому, то ставим Grub Customizer (пакет grub-customizer), открываем вкладку “Основные настройки”
# и добавляем threadirqs в строку с параметрами ядра.
# От себя скажу (напишу) этот метод видел в инете, но у себя изменения в файл grub НЕ вносил и всё работает, соглашусь что
# при установки Клиента 'PipeWire' он должен сработать...
###########  Справка по Alsamixer ################
# Запуск alsamixer:
# (Откройте в терминале. Будут отображены только необходимые настройки)
# Чтобы запустить звуковой микшер на основе графического интерфейса:
# alsamixer
# Чтобы изменить громкость через командную строку:
# amixer set Master 80%
############ Справка по Pulseaudio ############
# pulseaudio --check  # Проверьте, запущен ли какой-либо экземпляр pulseaudio ; Обычно он не выводит никаких выходных данных, только код выхода. 0 - Это означает, что процесс запущен.
# pulseaudio -k  # Если какой-либо экземпляр запущен, завершите его
# pulseaudio -D  # Наконец, запустите pulseaudio снова как демон
# sudo systemctl --user start pulseaudio
# sudo systemctl --user enable pulseaudio
######################################