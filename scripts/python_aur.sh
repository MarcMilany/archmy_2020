#!/bin/bash
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 
 echo ""
 echo " Обновление баз данных пакетов, и системы через - AUR (Yay) "
  yay -Syy
  yay -Syu
 echo ""
 echo " Установка - Python из AUR "
########## Python AUR ###########
yay -S python-basiciw --noconfirm  # Получение информации, такой как ESSID или качество сигнала, с беспроводных карт (модуль Python)
yay -S python-bencode.py --noconfirm  # Простой парсер бенкода (для Python 2, Python 3 и PyPy)
yay -S pythonqt --noconfirm  # Динамическая привязка Python для приложений Qt
yay -S python-coincurve --noconfirm  # Кросс-платформенные привязки Python CFFI для libsecp256k1
yay -S python-merkletools --noconfirm  # Инструменты Python для создания и проверки деревьев Меркла и доказательств
yay -S python-pyelliptic --noconfirm  # Оболочка Python OpenSSL для ECC (ECDSA, ECIES), AES, HMAC, Blowfish, ...
yay -S python-pyparted --noconfirm  # Модуль Python для GNU parted
yay -S python-pyqt4 --noconfirm  # Набор привязок Python 3.x для набора инструментов Qt
yay -S python-pywapi --noconfirm  # Обертка Python вокруг Yahoo! Погода, Weather.com и API NOAA
yay -S python-requests-cache --noconfirm  # Прозрачный постоянный кеш для библиотеки
yay -S python-sip-pyqt4 --noconfirm  # Привязки Python 3.x SIP для библиотек C и C ++ (версия PyQt4)
yay -S python-twitter --noconfirm  # Набор инструментов API и командной строки для Twitter (twitter.com)
########## Python2 AUR ###########
yay -S python2-imaging --noconfirm  # PIL. Предоставляет возможности обработки изображений для Python
# yay -S  --noconfirm  #
# yay -S  --noconfirm  #
# yay -S  --noconfirm  #
# yay -S  --noconfirm --needed  #
########## Python AUR (Биткойн) ###########
# yay -S python-base58 --noconfirm  # Биткойн-совместимая реализация Base58 и Base58Check
# yay -S python-bitcoinlib --noconfirm  # Библиотека Python3, обеспечивающая простой интерфейс для структур данных и протокола Биткойн
# yay -S  --noconfirm  #
###########################
###################################
###
########## Python AUR ###########
###
### python-basiciw    AUR  # Получение информации, такой как ESSID или качество сигнала, с беспроводных карт (модуль Python)
### https://aur.archlinux.org/packages/python-basiciw/
### https://aur.archlinux.org/python-basiciw.git
### https://github.com/enkore/basiciw/
###
### python-bencode.py    AUR  # Простой парсер бенкода (для Python 2, Python 3 и PyPy)
### https://aur.archlinux.org/packages/python-bencode.py/
### https://aur.archlinux.org/python-bencode.py.git 
### https://github.com/fuzeman/bencode.py
###
### pythonqt    AUR  # Динамическая привязка Python для приложений Qt
### https://aur.archlinux.org/packages/pythonqt/
### https://aur.archlinux.org/pythonqt.git
### http://pythonqt.sourceforge.net/
###
### python-coincurve   AUR  # Кросс-платформенные привязки Python CFFI для libsecp256k1
### https://aur.archlinux.org/packages/python-coincurve/
### https://aur.archlinux.org/python-coincurve.git
### https://github.com/ofek/coincurve
###
### python-merkletools   AUR  # Инструменты Python для создания и проверки деревьев Меркла и доказательств
### https://aur.archlinux.org/packages/python-merkletools/
### https://aur.archlinux.org/python-merkletools.git 
### https://github.com/Tierion/pymerkletools
###
### python-pyparted   AUR  # Модуль Python для GNU parted
### https://aur.archlinux.org/packages/python-pyparted/
### https://aur.archlinux.org/python-pyparted.git
### https://github.com/dcantrell/pyparted
###
### python-twitter   AUR  # Набор инструментов API и командной строки для Twitter (twitter.com)
### https://aur.archlinux.org/packages/python-twitter/
### https://aur.archlinux.org/python-twitter.git 
### http://pypi.python.org/pypi/twitter/
###
### python2-imaging  AUR  # PIL. Предоставляет возможности обработки изображений для Python
### https://aur.archlinux.org/packages/python2-imaging/
### https://aur.archlinux.org/python2-imaging.git 
### http://www.pythonware.com/products/pil/index.htm
###
### python-pyelliptic  AUR  # Оболочка Python OpenSSL для ECC (ECDSA, ECIES), AES, HMAC, Blowfish, ...
### https://aur.archlinux.org/packages/python-pyelliptic/
### https://aur.archlinux.org/python-pyelliptic.git
### https://github.com/radfish/pyelliptic
###
### python-pyqt4  AUR  # Набор привязок Python 3.x для набора инструментов Qt
### https://aur.archlinux.org/packages/python-pyqt4/
### https://aur.archlinux.org/pyqt4.git
### https://riverbankcomputing.com/software/pyqt/intro
###
### python-pywapi  AUR  # Обертка Python вокруг Yahoo! Погода, Weather.com и API NOAA
### https://aur.archlinux.org/packages/python-pywapi/
### https://aur.archlinux.org/python-pywapi.git
### https://launchpad.net/python-weather-api
###
### python-requests-cache  AUR  # Прозрачный постоянный кеш для библиотеки http://python-requests.org/ 
### https://aur.archlinux.org/packages/python-requests-cache/
### https://aur.archlinux.org/python-requests-cache.git
### https://github.com/reclosedev/requests-cache
###
### python-sip-pyqt4  AUR  # Привязки Python 3.x SIP для библиотек C и C ++ (версия PyQt4)
### https://aur.archlinux.org/packages/python-sip-pyqt4/
### https://aur.archlinux.org/python-sip-pyqt4.git
### https://www.riverbankcomputing.com/software/sip/intro
###
########## Биткойн ###########
###
### python-base58   AUR  # Биткойн-совместимая реализация Base58 и Base58Check
### https://aur.archlinux.org/packages/python-base58/
### https://aur.archlinux.org/python-base58.git 
### https://github.com/keis/base58
###
### python-bitcoinlib # Библиотека Python3, обеспечивающая простой интерфейс для структур данных и протокола Биткойн
### https://www.archlinux.org/packages/community/any/python-bitcoinlib/
### https://github.com/petertodd/python-bitcoinlib
###
###############################


