#!/bin/bash
# loadkeys ru
# setfont cyr-sun16
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! ####
# sudo sh clamav_update_auto.sh
sudo systemctl stop clamav-freshclam
sudo rm -rf /var/lib/clamav/*
#sudo systemctl stop clamav-freshclam
sudo wget https://unlix.ru/clamav/main.cvd -O /var/lib/clamav/main.cvd 
sudo wget https://unlix.ru/clamav/daily.cvd -O /var/lib/clamav/daily.cvd 
sudo wget https://unlix.ru/clamav/bytecode.cvd -O /var/lib/clamav/bytecode.cvd
#systemctl start clamav-freshclam   # Перезапустите сервис ClamAV (хотя не обязательно)
echo ""
echo " Создать файл (скрипт) update_clamav.sh в ./ (root) "
sudo touch ./update_clamav.sh   # Создать файл ./update_clamav.sh
echo " Пропишем конфигурации в файл ./update_clamav.sh "
cat > ./update_clamav.sh << EOF
#!/bin/bash

systemctl stop clamav-freshclam
rm -rf /var/lib/clamav/*
wget https://unlix.ru/clamav/main.cvd -O /var/lib/clamav/main.cvd 
wget https://unlix.ru/clamav/daily.cvd -O /var/lib/clamav/daily.cvd 
wget https://unlix.ru/clamav/bytecode.cvd -O /var/lib/clamav/bytecode.cvd

EOF
###########
echo " Сделайте задание cron файл update_clamav.sh исполняемым "
sudo chmod a+x ./update_clamav.sh
echo " Добавим задание в cron для еженедельного обновления антивирусных баз ClamAV "
sudo echo "0 0 * * 0 root /root/update_clamav.sh" >> /etc/crontab
###########
echo " Перезапустить сервис ClamAV (хотя не обязательно) "
sudo systemctl start clamav-freshclam
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
### end of script