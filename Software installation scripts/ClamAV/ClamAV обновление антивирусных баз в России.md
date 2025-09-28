ClamAV обновление антивирусных баз в России
https://clamav-mirror.ru/
mirror.truenetwork.ru

ClamAV обновление антивирусных баз в России
Скачать последние обновления антивирусных баз open source ClamAV можно с нешего зеркала репозитория (ClamAV mirror) на территории РФ.

wget https://clamav-mirror.ru/main.cvd
wget https://clamav-mirror.ru/daily.cvd
wget https://clamav-mirror.ru/bytecode.cvd

Если вместо domain-name планируете использовать wget по IP, тогда:

wget http://94.247.111.11/clamav/main.cvd
wget http://94.247.111.11/clamav/daily.cvd
wget http://94.247.111.11/clamav/bytecode.cvd

Для автоматического обновления следует добавить в конфигурационный файл /etc/clamav/freshclam.conf строки:

PrivateMirror https://clamav-mirror.ru/
PrivateMirror https://mirror.truenetwork.ru/clamav/
PrivateMirror http://mirror.truenetwork.ru/clamav/
ScriptedUpdates no

Удаляем старый файлы с данными об обновлении баз

sudo rm /var/lib/clamav/freshclam.dat

Запускаем обновление баз вручную

sudo freshclam -vvv

Наше зеркало выполняет обновление каждый час