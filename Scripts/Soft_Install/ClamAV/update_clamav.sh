#!/bin/bash

systemctl stop clamav-freshclam
rm -rf /var/lib/clamav/*
wget https://unlix.ru/clamav/main.cvd -O /var/lib/clamav/main.cvd 
wget https://unlix.ru/clamav/daily.cvd -O /var/lib/clamav/daily.cvd 
wget https://unlix.ru/clamav/daily.cvd -O /var/lib/clamav/daily.cvd 
systemctl start clamav-freshclam   # Перезапустите сервис ClamAV (хотя не обязательно)
