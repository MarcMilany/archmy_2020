Введение в Fcron
Пакет Fcron содержит планировщик периодических команд, призванный заменить Vixie Cron .

https://linuxfromscratch.org/~pierre/blfs-book/general/fcron.html

[Примечание] Примечание
Разрабатываемые версии BLFS могут не собирать или не запускать некоторые пакеты должным образом, если LFS или зависимости были обновлены с момента выхода последних стабильных версий книг.

Информация о пакете
Загрузить (HTTP): http://fcron.free.fr/archives/fcron-3.2.1.src.tar.gz

Скачать MD5-сумму: bd4996e941a40327d11efc5e3fd1f839

Размер загрузки: 587 КБ

Предполагаемый объем необходимого дискового пространства: 5,1 МБ

Расчетное время сборки: 0,1 SBU

Зависимости Fcron
Необязательный
MTA , текстовый редактор (по умолчанию vi из пакета Vim-9.0.2189 ), Linux -PAM-1.6.0 и DocBook-utils-0.6.14

Установка Fcron
Fcron использует cron-функцию syslog для ведения журнала всех сообщений. Поскольку LFS не настраивает эту функцию в /etc/syslog.conf, её необходимо настроить до установки Fcron . Эта команда добавит необходимую строку в текущий файл /etc/syslog.conf(выполняйте от имени rootпользователя):

cat >> /etc/syslog.conf << "EOF"
# Begin fcron addition to /etc/syslog.conf

cron.* -/var/log/cron.log

# End fcron addition
EOF
Файл конфигурации был изменен, поэтому перезагрузка демона sysklogd активирует изменения (снова от имени rootпользователя).

/etc/rc.d/init.d/sysklogd reload
В целях безопасности следует создать непривилегированного пользователя и группу для Fcronroot (выполняйте действия от имени пользователя):

groupadd -g 22 fcron &&
useradd -d /dev/null -c "Fcron User" -g fcron -s /bin/false -u 22 fcron
Теперь исправим некоторые места, жестко прописанные в документации:

find doc -type f -exec sed -i 's:/usr/local::g' {} \;
Установите Fcron , выполнив следующие команды:

./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --localstatedir=/var   \
            --without-sendmail     \
            --with-boot-install=no \
            --with-systemdsystemunitdir=no &&
make
В этот пакет не входит тестовый набор.

Теперь, как rootпользователь:

make install
Установка в DESTDIR должна выполняться от имени rootпользователя. Кроме того, если файлы конфигурации PAM должны быть установлены в /etc/pam.d, необходимо создать этот каталог в DESTDIR перед установкой.

Пояснения команд
--without-sendmail: По умолчанию Fcron попытается использовать команду sendmail из пакета MTA для отправки вам результатов работы скрипта fcron по электронной почте . Этот параметр отключает уведомления по электронной почте по умолчанию. Не указывайте этот параметр, чтобы включить уведомления по умолчанию. Кроме того, вы можете использовать команду , чтобы использовать другую команду почтовой программы. --with-sendmail=</path/to/MTA command>

--with-boot-install=no: Это предотвращает установку загрузочного скрипта, входящего в пакет.

--with-systemdsystemunitdir=no: Это предотвращает сборку модулей systemd , которые не нужны для системы SYS V.

--with-editor=</path/to/editor>: Этот переключатель позволяет установить текстовый редактор по умолчанию.

--with-dsssl-dir=</path/to/dsssl-stylesheets>: Можно использовать, если установлен DocBook-utils-0.6.14 . В настоящее время таблицы стилей dsssl находятся в /usr/share/sgml/docbook/dsssl-stylesheets-1.79.

Настройка Fcron
Файлы конфигурации
/etc/fcron.conf, /etc/fcron.allow, и/etc/fcron.deny

Информация о конфигурации
Никаких изменений в конфигурационных файлах не требуется. Информацию о конфигурации можно найти на странице руководства для fcron.conf.

Скрипты fcron пишутся с использованием fcrontab . Обратитесь к странице руководства fcrontab , чтобы узнать параметры, подходящие для вашей ситуации.

Если установлен Linux-PAM , в папке устанавливаются два файла конфигурации PAM etc/pam.d. Если же etc/pam.dон не используется, программа установки добавит два раздела конфигурации к существующему /etc/pam.confфайлу. Убедитесь, что файлы соответствуют вашим предпочтениям. Измените их в соответствии с вашими потребностями.

Периодические работы
Если вы хотите настроить периодическую иерархию для пользователя root, сначала выполните следующие команды (как rootпользователь), чтобы создать /usr/bin/run-partsскрипт:

cat > /usr/bin/run-parts << "EOF" &&
#!/bin/sh
# run-parts:  Runs all the scripts found in a directory.
# from Slackware, by Patrick J. Volkerding with ideas borrowed
# from the Red Hat and Debian versions of this utility.

# keep going when something fails
set +e

if [ $# -lt 1 ]; then
  echo "Usage: run-parts <directory>"
  exit 1
fi

if [ ! -d $1 ]; then
  echo "Not a directory: $1"
  echo "Usage: run-parts <directory>"
  exit 1
fi

# There are several types of files that we would like to
# ignore automatically, as they are likely to be backups
# of other scripts:
IGNORE_SUFFIXES="~ ^ , .bak .new .rpmsave .rpmorig .rpmnew .swp"

# Main loop:
for SCRIPT in $1/* ; do
  # If this is not a regular file, skip it:
  if [ ! -f $SCRIPT ]; then
    continue
  fi
  # Determine if this file should be skipped by suffix:
  SKIP=false
  for SUFFIX in $IGNORE_SUFFIXES ; do
    if [ ! "$(basename $SCRIPT $SUFFIX)" = "$(basename $SCRIPT)" ]; then
      SKIP=true
      break
    fi
  done
  if [ "$SKIP" = "true" ]; then
    continue
  fi
  # If we've made it this far, then run the script if it's executable:
  if [ -x $SCRIPT ]; then
    $SCRIPT || echo "$SCRIPT failed."
  fi
done

exit 0
EOF
chmod -v 755 /usr/bin/run-parts
Далее создайте структуру каталога для периодических заданий (снова от имени rootпользователя):

install -vdm754 /etc/cron.{hourly,daily,weekly,monthly}
Наконец, добавьте части запуска в системный fcrontab (пока вы являетесь rootпользователем):

cat > /var/spool/fcron/systab.orig << "EOF"
&bootrun 01 * * * * root run-parts /etc/cron.hourly
&bootrun 02 4 * * * root run-parts /etc/cron.daily
&bootrun 22 4 * * 0 root run-parts /etc/cron.weekly
&bootrun 42 4 1 * * root run-parts /etc/cron.monthly
EOF
Скрипт загрузки
Установите /etc/rc.d/init.d/fcronскрипт инициализации из пакета blfs-bootscripts-20231119 .

make install-fcron
Наконец, снова как rootпользователь, запустите fcron и сгенерируйте /var/spool/fcron/systabфайл:

/etc/rc.d/init.d/fcron start &&
fcrontab -z -u systab
Содержание
Установленные программы:
fcron, fcrondyn, fcronsighup и fcrontab
Установленные библиотеки:
Никто
Установленные каталоги:
/usr/share/doc/fcron-3.2.1 и /var/spool/fcron
Краткие описания
fcron

это демон планирования

фкрондин

— это пользовательский инструмент, предназначенный для взаимодействия с работающим демоном fcron

fcronsighup

дает команду fcron перечитать таблицы Fcron

fcrontab

это программа, используемая для установки, редактирования, перечисления и удаления таблиц, используемых fcron