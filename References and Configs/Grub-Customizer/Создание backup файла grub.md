  echo " Перед началом установки Grub2-Theme-Vimix создадим резервную копию файлов конфигурации Grub "
  echo ""
  echo " Создать резервную копию файлов конфигурации Grub "
  echo " Создать папку для резервного копирования в домашнем каталоге пользователя "
mkdir -p ~/grub-backup
  echo ""
  echo " Создание дубликата файла grub в директории исходника "
cp -vf /etc/default/grub /etc/default/grub.backup0  # -v, --verbose - максимально подробный вывод ; -f, --force - удалить файл назначения перед попыткой записи в него если он существует
echo " Создание backup файла grub выполнено "
  echo ""
  echo " Скопировать файл конфигурации Grub из папки /etc/default/grub в папку grub-backup "
#cp /etc/default/grub ~/grub-backup/
cp -vf /etc/default/grub ~/grub-backup/
cp -vf /etc/default/grub.backup0 ~/grub-backup/
echo " Копирование файла grub выполнено "
  echo ""
  echo " Создание дубликата файла grub.cfg в директории исходника "
cp -vf /boot/grub/grub.cfg /boot/grub/grub.cfg.backup0  # -v, --verbose - максимально подробный вывод ; -f, --force - удалить файл назначения перед попыткой записи в него если он существует
echo " Создание backup файла grub.cfg выполнено "
  echo ""
  echo " Скопировать файл конфигурации Grub из папки /boot/grub/grub.cfg в папку grub-backup "
#cp /boot/grub/grub.cfg ~/grub-backup/
cp -vf /boot/grub/grub.cfg ~/grub-backup/
cp -vf /etc/default/grub.cfg.backup0 ~/grub-backup/
echo " Копирование файла grub.cfg выполнено "
  echo ""
  echo " Скопировать файлы из папки /etc/grub.d (где находятся остальные конфигурации Grub) в папку grub-backup "
cp -a /etc/grub.d ~/grub-backup  # -a - режим резервного копирования, при котором сохраняются все атрибуты, ссылки, а также выполняется резервное копирование папок, аналогично --recursive --preserve=all, --no-dereference;
# cp -a /etc/grub.d /etc/grub.d/grub-backup/grub.d  # создаёт резервную копию файлов конфигурации загрузчика Grub из каталога /etc/grub.d
echo " Копирование папки /etc/grub.d выполнено "


Создать резервную копию файлов конфигурации Grub:
Создать папку для резервного копирования в домашнем каталоге пользователя с помощью команды mkdir -p ~/grub-backup.
Скопировать файл конфигурации Grub из папки /etc/default/grub в папку grub-backup. Для этого нужно выполнить команду cp /etc/default/grub ~/grub-backup/.
Скопировать файлы из папки /etc/grub.d (где находятся остальные конфигурации Grub) в папку grub-backup. Для этого нужно выполнить команду cp -a /etc/grub.d ~/grub-backup.

cp -a /etc/grub.d /etc/grub.d/grub-backup/grub.d

Команда cp -a /etc/grub.d /etc/grub.d/grub-backup/grub.d создаёт резервную копию файлов конфигурации загрузчика Grub из каталога /etc/grub.d. 

Объяснение:
/etc/grub.d — каталог, где находятся файлы конфигурации Grub.
/etc/grub.d/grub-backup/grub.d — путь к файлу, который будет создан в папке grub-backup в домашнем каталоге пользователя.

Цель: создать резервную копию файлов конфигурации Grub перед изменениями в настройках загрузчика, чтобы в случае ошибок можно было восстановить оригинальные конфигурации. 
maketecheasier.com
Важно: перед выполнением команды рекомендуется создать папку для резервной копии в домашнем каталоге пользователя с помощью команды mkdir -p ~/grub-backup. 
