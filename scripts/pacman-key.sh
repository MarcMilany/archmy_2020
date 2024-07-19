#!/usr/bin/env bash
# Install script xdg-user-dirs
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
# wget git.io/xdg-user-dirs.sh && sh xdg-user-dirs.sh

echo ""
echo -e "${YELLOW}==> ${NC}Обновить и добавить новые ключи?"
echo " Данный этап поможет вам избежать проблем с ключами Pacmаn, если Вы использовали не свежий образ ArchLinux для установки! "
echo -e "${RED}==> ${YELLOW}Примечание: ${BOLD}- Иногда при запуске обновления ключей по hkp возникает ошибка, не переживайте просто при установке gnupg в линукс в дефолтном конфиге указан следующий сервер: (keyserver hkp://keys.gnupg.net). GnuPG - оснащен универсальной системой управления ключами, а также модулями доступа для всех типов открытых ключей. GnuPG, также известный как GPG, это инструмент командной строки с возможностью легкой интеграции с другими приложениями. Доступен богатый выбор пользовательских приложений и библиотек. ${NC}"
echo -e "${RED}==> ${BOLD}Примечание: - Однако, в ходе чтения различных руководств в интернете было выяснено, что подобный способ обновления и передачи ключей не самый лучший, т.к. эта информация передается открытым способом. И тот, кто наблюдает за траффиком, видит данные обновляемых при gpg -refresh-keys ключей. И поэтому рекомендуется использовать hkps сервера - (keyserver hkps://hkps.pool.sks-keyservers.net)! ${NC}"
echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, можно пропустить запуск обновления ключей. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да обновить ключи,    0 - Нет пропустить: " x_key  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$x_key" =~ [^10] ]]
do
    :
done
 if [[ $x_key == 0 ]]; then
  echo ""
  echo " Обновление ключей пропущено "
  echo ""
  echo -e "${BLUE}:: ${NC}Обновим базы данных пакетов"
  sudo pacman -Sy --noconfirm  # обновить списки пакетов из репозиториев
elif [[ $x_key == 1 ]]; then
  clear
  echo ""
  echo " Обновим списки пакетов из репозиториев и установим Брелок Arch Linux PGP - пакет (archlinux-keyring) "
  sudo pacman -Syy archlinux-keyring --noconfirm  # Брелок Arch Linux PGP ; https://archlinux.org/packages/core/any/archlinux-keyring/
  echo " Выполним резервное копирование каталога (/etc/pacman.d/gnupg), на всякий случай "
# Файлы конфигурации по умолчанию: ~/.gnupg/gpg.conf и ~/.gnupg/dirmngr.conf.
  sudo cp -R /etc/pacman.d/gnupg /etc/pacman.d/gnupg_back
# Я тебе советовал перед созданием нового брелка удалить директории (но /root/.gnupg не удалена)
  echo " Удалим директорию (/etc/pacman.d/gnupg) "
  sudo rm -R /etc/pacman.d/gnupg
# sudo rm -r /etc/pacman.d/gnupg
# sudo mv /usr/lib/gnupg/scdaemon{,_}  # если демон смарт-карт зависает (это можно обойти с помощью этой команды)
  echo " Выполним резервное копирование каталога (/root/.gnupg), на всякий случай "
  sudo cp -R /root/.gnupg /root/.gnupg_back
# echo " Удалим директорию (/etc/pacman.d/gnupg) "
# sudo rm -R /root/.gnupg
  echo " Создаётся генерация мастер-ключа (брелка) pacman "  # gpg –refresh-keys
  sudo pacman-key --init  # генерация мастер-ключа (брелка) pacman
  echo " Далее идёт поиск ключей... "
  sudo pacman-key --populate archlinux  # поиск ключей
# sudo pacman-key --populate
  echo " Брелок для ключей Arch Linux PGP (Репозиторий для пакета связки ключей Arch Linux) "
  sudo pacman -Sy --noconfirm --needed --noprogressbar --quiet archlinux-keyring  # Брелок для ключей Arch Linux PGP https://git.archlinux.org/archlinux-keyring.git/ (для hkps://hkps.pool.sks-keyservers.net)
  echo ""
  echo " Обновление ключей... "
  sudo pacman-key --refresh-keys
#  sudo pacman-key --refresh-keys --keyserver keys.gnupg.net  # http://pool.sks-keyservers.net/
# sudo pacman-key --refresh-keys --keyserver hkp://pool.sks-keyservers.net  # hkps://hkps.pool.sks-keyservers.net
## Предлагается сделать следующие изменения в конфиге gnupg:
## keyserver hkps://hkps.pool.sks-keyservers.net
## keyserver-options ca-cert-file=/path/to/CA/sks-keyservers.netCA.pem
## где sks-keyservers.netCA.pem – есть сертификат, загружаемый с wwwhttps://sks-keyservers.net/sks-keyservers.netCA.pem
# sudo pacman-key --refresh-keys --keyserver hkps://hkps.pool.sks-keyservers.net
# sudo keyserver-options ca-cert-file=/path/to/CA/sks-keyservers.netCA.pem
  echo ""
  echo "Обновим базы данных пакетов..."
###  sudo pacman -Sy  # обновить списки пакетов из репозиториев
  sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # Обновим вашу систему (базу данных пакетов)
# sudo pacman -Syyu  --noconfirm
echo ""
echo " Обновление и добавление новых ключей выполнено "
fi

sleep 2

clear

# Успех
#Success
echo "Установка завершена! Перезагрузить."
#echo "Installation complete! Reboot."

# <<< Делайте выводы сами! >>>

