#!/bin/bash
# loadkeys ru
# setfont cyr-sun16
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! ####
# sudo sh clamav_update_auto.sh
echo ""
echo " Установка антивирусных баз для ClamAV ® (Clam Antivirus) "
echo ""
echo " Оставливаем сервис 'clamav-freshclam' "
sudo systemctl stop clamav-freshclam  # остановите службу автоматического обновления
echo ""
echo " Удаляем старый файлы с данными об обновлении баз "
sudo rm -rf /var/lib/clamav/*
echo ""
echo " Обновление антивирусны баз ClamAV в России с зеркала репозитория (ClamAV mirror) на территории РФ "
echo " *Примечание: Рабочее зеркало обновления антивирусны баз, но с задержкой обновления (баз):
         The virus database is older than 7 days! "
################ Вариант 1 ################
#sudo systemctl stop clamav-freshclam
echo ""
sudo wget https://clamav-mirror.ru/main.cvd -O /var/lib/clamav/main.cvd
sudo wget wget https://clamav-mirror.ru/daily.cvd -O /var/lib/clamav/daily.cvd
sudo wget https://clamav-mirror.ru/bytecode.cvd -O /var/lib/clamav/bytecode.cvd
echo ""
################ Вариант 2 ################
#echo ""
#echo " Обновление антивирусны баз ClamAV из России на UNLIX.ru "
#echo " *Примечание: Рабочее зеркало обновления антивирусны баз, но с задержкой обновления (баз):
#         The virus database is older than 7 days! "
#echo ""
#sudo wget https://unlix.ru/clamav/main.cvd -O /var/lib/clamav/main.cvd
#sudo wget https://unlix.ru/clamav/daily.cvd -O /var/lib/clamav/daily.cvd
#sudo wget https://unlix.ru/clamav/bytecode.cvd -O /var/lib/clamav/bytecode.cvd
#echo ""
################ Вариант 3 ################
#echo ""
#echo " Обновление антивирусны баз ClamAV в России на территории РФ "
#echo " Если вместо domain-name планируете использовать wget по IP "
#echo ""
#sudo wget http://94.247.111.11/clamav/main.cvd -O /var/lib/clamav/main.cvd
#sudo wget http://94.247.111.11/clamav/daily.cvd -O /var/lib/clamav/daily.cvd
#sudo wget http://94.247.111.11/clamav/bytecode.cvd -O /var/lib/clamav/daily.cvd
#echo ""
###################
echo ""
echo " Перезапустить службу (clamav-freshclam) автоматического обновления ClamAV (хотя не обязательно) "
sudo systemctl enable --now clamav-freshclam
sudo systemctl start clamav-freshclam  # запускает службу автоматического обновления вирусных баз (freshclam) для антивируса ClamAV
### Служба freshclam обновляет базу данных ClamAV с последними вирусными сигнатурами. Это важно, чтобы программа могла эффективно обнаруживать и нейтрализовать последние угрозы.
# sudo systemctl stop clamav-freshclam  # остановите службу автоматического обновления
# sudo systemctl status clamav-freshclam  # статус службы автоматического обновления вирусных баз (freshclam)
echo ""
echo " Запустить службу демона (clamav-daemon) антивируса ClamAV для автоматического сканирования файлов и каталогов "
# sudo systemctl enable clamav-daemon.service
sudo systemctl enable --now clamav-daemon
sudo systemctl start clamav-daemon  # запускает службу демона антивируса ClamAV для автоматического сканирования файлов и каталогов в режиме реального времени
### Служба clamav-daemon обеспечивает фоновое сканирование файлов и каталогов, которое происходит при обращении к ним. Это позволяет:
### Запускать сканирование для определённых каталогов (например, /home, /etc, /var).
### Проверять файлы при их создании, перемещении или переименовании (опция OnAccessExtraScanning).
### Исключать проверку файлов при обращении к ним указанного пользователя (опция OnAccessExcludeUID).
# sudo systemctl status clamav-daemon  # статус запуска clamav-daemon – который предоставляет нам API для проверки файлов
echo ""
echo " Установка антивирусных баз ClamAV завершена "
echo " Теперь Ваш ClamAV будет обновляться даже с российских IP совершенно бесплатно "
sleep 03
echo ""
echo " Создать файл (скрипт) update_clamav.sh в ./ (root) "
sudo touch ./update_clamav.sh   # Создать файл ./update_clamav.sh
echo " Пропишем конфигурации в файл ./update_clamav.sh "
cat > ./update_clamav.sh << EOF
#!/bin/bash

systemctl stop clamav-freshclam
rm -rf /var/lib/clamav/*
################ Вариант 1 ################
### Обновление антивирусны баз ClamAV в России с зеркала репозитория (ClamAV mirror) на территории РФ
### *Примечание: Рабочее зеркало обновления антивирусны баз, но с задержкой обновления (баз):
###         The virus database is older than 7 days!
wget https://clamav-mirror.ru/main.cvd -O /var/lib/clamav/main.cvd
wget wget https://clamav-mirror.ru/daily.cvd -O /var/lib/clamav/daily.cvd
wget https://clamav-mirror.ru/bytecode.cvd -O /var/lib/clamav/bytecode.cvd
################ Вариант 2 ################
### Обновление антивирусны баз ClamAV из России на UNLIX.ru
### *Примечание: Рабочее зеркало обновления антивирусны баз, но с задержкой обновления (баз):
###         The virus database is older than 7 days!
#wget https://unlix.ru/clamav/main.cvd -O /var/lib/clamav/main.cvd
#wget https://unlix.ru/clamav/daily.cvd -O /var/lib/clamav/daily.cvd
#wget https://unlix.ru/clamav/bytecode.cvd -O /var/lib/clamav/bytecode.cvd
################ Вариант 3 ################
### Обновление антивирусны баз ClamAV в России на территории РФ
### Если вместо domain-name планируете использовать wget по IP
#wget http://94.247.111.11/clamav/main.cvd -O /var/lib/clamav/main.cvd
#wget http://94.247.111.11/clamav/daily.cvd -O /var/lib/clamav/daily.cvd
#wget http://94.247.111.11/clamav/bytecode.cvd -O /var/lib/clamav/daily.cvd

EOF
###########
echo " Сделайте задание cron файл update_clamav.sh исполняемым "
sudo chmod a+x ./update_clamav.sh
echo " Добавим задание в cron для еженедельного обновления антивирусных баз ClamAV "
sudo echo "0 0 * * 0 root /root/update_clamav.sh" >> /etc/crontab
###########
echo " Перезапустить сервис ClamAV (хотя не обязательно) "
sudo systemctl start clamav-freshclam
# sudo systemctl start clamav-daemon
echo " Установка антивирусных баз ClamAV завершена "
echo " Теперь Ваш ClamAV будет обновляться даже с российских IP совершенно бесплатно "
sleep 02
############ Справка ####################
# Как обновить ClamAV из России
# https://unlix.ru/%D0%BA%D0%B0%D0%BA-%D0%BE%D0%B1%D0%BD%D0%BE%D0%B2%D0%B8%D1%82%D1%8C-clamav-%D0%B8%D0%B7-%D1%80%D0%BE%D1%81%D1%81%D0%B8%D0%B8/
# С российских IP запрещён доступ не только к обновлениям, но ко всему домену clamav.net
# Как обновить ClamAV в этом случае?
# Вариант 1
# Остановите сервис ClamAV
# root@unlix:~# systemctl stop clamav-freshclam
# Скачайте через Tor или VPN файлы:
# wget http://database.clamav.net/main.cvd
# wget http://database.clamav.net/daily.cvd
# wget http://database.clamav.net/bytecode.cvd
#####################
# Поместите их в директорию /var/lib/clamav/
# Перезапустите сервис ClamAV (хотя не обязательно)
# root@unlix:~# systemctl start clamav-freshclam
####################
# Вариант 2
# Обновление баз ClamAV, российское зеркало TENDENCE
# К сожалению, известное российское зеркало ClamAV теперь требует купить подписку на обновления. После оплаты Вы получите ссылки на обновления. Тогда можно будет проделать следующие шаги.
# Либо скачать последние обновления антивирусных баз можно с российского зеркала (ClamAV mirror) и положить их в /var/lib/clamav/:
# https://tendence.ru/clamav/main.cvd
# https://tendence.ru/clamav/daily.cvd
# https://tendence.ru/clamav/bytecode.cvd
# Либо для автоматического обновления следует добавить в конфигурационный файл /etc/clamav/freshclam.conf строки:
# PrivateMirror https://tendence.ru/clamav
# ScriptedUpdates no
#######################
# ClamAV обновление антивирусных баз в России
# https://clamav-mirror.ru/
# mirror.truenetwork.ru
# https://unlix.ru/clamav
# ClamAV обновление антивирусных баз в России
# Наше зеркало выполняет обновление каждый час
# Удаляем старый файлы с данными об обновлении баз
# sudo rm -rf /var/lib/clamav/*
# или так
# sudo rm /var/lib/clamav/freshclam.dat
# Для автоматического обновления следует добавить следующее
# в конфигурационный файл /etc/clamav/freshclam.conf строки:
# PrivateMirror https://clamav-mirror.ru/
# PrivateMirror https://mirror.truenetwork.ru/clamav/
# PrivateMirror http://mirror.truenetwork.ru/clamav/
# ScriptedUpdates no
### *Также сделать следующее при ошибке обновление баз:
# Я столкнулся с этой проблемой на своей Ubuntu 20.04 LTS , машине
# Вот что я сделал:
# sudo systemctl stop clamav-daemon.service
# затем sudo rm /var/log/clamav/freshclam.log (иногда его блокируют)
# Добавьте sock-файл для ClamAV:
# sudo touch /var/lib/clamav/clamd.sock
# sudo chown clamav:clamav /var/lib/clamav/clamd.sock
# Затем отредактируйте /etc/clamav/clamd.conf- раскомментируйте эту строку:
# LocalSocket /var/lib/clamav/clamd.sock
# Добавьте sock-файл для ClamAV:
# sudo touch /run/clamav/clamd.sock
# sudo chown clamav:clamav /run/clamav/clamd.sock
# sudo systemctl restart clamav-daemon.service
# запустить службу sudo systemctl start clamav-daemon.service
# чтобы убедиться, что все в порядке, запустите sudo systemctl status clamav-daemon.service
# Запускаем обновление баз вручную
# sudo freshclam
### Запускаем обновление баз вручную
# sudo freshclam -vvv
# или sudo freshclam
# Перезапустить службу демона clamav-daemon и сервис ClamAV (clamav-freshclam хотя не обязательно)
# sudo systemctl start clamav-freshclam   # Перезапустите сервис ClamAV (хотя не обязательно) ;  запускает службу автоматического обновления вирусных баз (freshclam) для антивируса ClamAV
# sudo systemctl start clamav-daemon   # запускает службу демона антивируса ClamAV для автоматического сканирования файлов и каталогов в режиме
# Проверка работы ClamAV:
# Для проверки работы сканера ClamAV от имени обычного пользователя ввести:
# curl https://secure.eicar.org/eicar.com.txt | clamscan -
# В результатах сканирования должна быть строка:
# stdin: Win.Test.EICAR_HDB-1 FOUND
# X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*
# Сканирование файлов с помощью ClamAV:
# Для сканирования файлов и каталогов пользователя в терминале можно ввести команду:
# clamscan --recursive --infected /home/user1/<путь_до_каталога>
# clamscan --recursive --infected /tmp
### Наше зеркало выполняет обновление каждый час
##################################################
### end of script