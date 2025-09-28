#!/bin/bash

path=$(dirname $(realpath "$0"))

read -p "Create link to komander-tool? (y/n) " cmf
if [ $cmf == "y" ]; then
  :
else
  exit 0
fi
sudo ln -s ${path}/komander-tool.sh /usr/local/bin/komander
komander setup
