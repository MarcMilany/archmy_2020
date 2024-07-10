#!/bin/bash
# reflector --list-countries

if [ "$(which curl)" != "curl not found" ]; then
  check_country=$(curl -s https://ipinfo.io/country)
fi

if [ "$1" = "-lc" ]; then
  # mirrors -lc
  sudo reflector -c "$check_country" -c "RU" -c "BY" -c "YA" -c "KZ" -c "PL" -c "GR" -c "FR" -c "DE" -a 12 -l 50 -f 20 -p https -p http --sort rate --save /etc/pacman.d/mirrorlist
# sudo reflector -c "$check_country" -c "Russia" -c "Belarus" -c "Ukraine" -c "Kazakhstan" -c "Poland" -c "Greece" -c "France" -c "Germany" -a 12 -l 50 -f 20 -p https -p http --sort rate --save /etc/pacman.d/mirrorlist
elif [ "$1" = "-c" ]; then
  # mirrors -c
  sudo reflector -c "$check_country" -f 20 -p https -p http --sort rate --save /etc/pacman.d/mirrorlist
else
  # mirrors
  sudo reflector --verbose -a 12 -l 50 -f 15  -p https -p http --sort rate --save /etc/pacman.d/mirrorlist
fi

sudo pacman -Syy




