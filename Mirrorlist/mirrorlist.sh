#!/bin/bash

##команда отфильтрует 7 зеркал russia, отсортирует по скорости и обновит файл mirrorlist##
sudo reflector --verbose --country Russia -l 7 -p https -p http -n 7 --save /etc/pacman.d/mirrorlist --sort rate

##команда отфильтрует 12 зеркал russia, отсортирует по скорости и обновит файл mirrorlist##
#sudo reflector -c "Russia" -f 12 -l 12 --verbose --save /etc/pacman.d/mirrorlist

##команда отфильтрует 12 зеркал, отсортирует по скорости и обновит файл mirrorlist##
#sudo reflector --verbose -l 12 --sort rate --save /etc/pacman.d/mirrorlist

##команда подробно выведет список 200 наиболее недавно обновленных http-зеркал, отсортирует по скорости и обновит mirrorlist##
#sudo reflector --verbose -l 200 -p http --sort rate --save /etc/pacman.d/mirrorlist

##команда подробно выведет список 200 наиболее недавно обновленных usa http-зеркал, отсортирует по скорости и обновит mirrorlist##
#reflector --verbose --country 'United States' -l 200 -p http --sort rate --save /etc/pacman.d/mirrorlist

notify-send "mirrorlist обновлен" -i gtk-info