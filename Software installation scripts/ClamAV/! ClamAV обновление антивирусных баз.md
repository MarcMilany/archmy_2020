ClamAV обновление антивирусных баз в России
Наше зеркало выполняет обновление каждый час
https://clamav-mirror.ru/
mirror.truenetwork.ru
https://unlix.ru/clamav

ClamAV обновление антивирусных баз в России
Скачать последние обновления антивирусных баз open source ClamAV можно с нешего зеркала репозитория (ClamAV mirror) на территории РФ.

wget https://clamav-mirror.ru/main.cvd
wget https://clamav-mirror.ru/daily.cvd
wget https://clamav-mirror.ru/bytecode.cvd

Если вместо domain-name планируете использовать wget по IP, тогда:

wget http://94.247.111.11/clamav/main.cvd
wget http://94.247.111.11/clamav/daily.cvd
wget http://94.247.111.11/clamav/bytecode.cvd


Обновление антивирусны баз ClamAV из России на UNLIX.ru:

wget https://unlix.ru/clamav/main.cvd -O /var/lib/clamav/main.cvd
wget https://unlix.ru/clamav/daily.cvd -O /var/lib/clamav/daily.cvd
wget https://unlix.ru/clamav/bytecode.cvd -O /var/lib/clamav/bytecode.cvd


Сначала остановите службу автоматического обновления clamav-freshclam

sudo systemctl stop clamav-freshclam  # остановите службу автоматического обновления

Удаляем старый файлы с данными об обновлении баз

sudo rm -rf /var/lib/clamav/*
или так
# sudo rm /var/lib/clamav/freshclam.dat

Для автоматического обновления следует добавить в конфигурационный файл /etc/clamav/freshclam.conf строки:

/etc/clamav/freshclam.conf

PrivateMirror https://clamav-mirror.ru/
PrivateMirror https://mirror.truenetwork.ru/clamav/
PrivateMirror http://mirror.truenetwork.ru/clamav/
ScriptedUpdates no

Запускаем обновление баз вручную

sudo freshclam -vvv

Перезапустить службу демона clamav-daemon и сервис ClamAV (clamav-freshclam хотя не обязательно):

sudo systemctl start clamav-freshclam   # Перезапустите сервис ClamAV (хотя не обязательно) ;  запускает службу автоматического обновления вирусных баз (freshclam) для антивируса ClamAV
sudo systemctl start clamav-daemon   # запускает службу демона антивируса ClamAV для автоматического сканирования файлов и каталогов в режиме
###
Проверка работы ClamAV:
Для проверки работы сканера ClamAV от имени обычного пользователя ввести:

curl https://secure.eicar.org/eicar.com.txt | clamscan -

В результатах сканирования должна быть строка:

stdin: Win.Test.EICAR_HDB-1 FOUND
X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*

Сканирование файлов с помощью ClamAV:
Для сканирования файлов и каталогов пользователя в терминале можно ввести команду:
clamscan --recursive --infected /home/user1/<путь_до_каталога>
clamscan --recursive --infected /tmp
### Наше зеркало выполняет обновление каждый час





