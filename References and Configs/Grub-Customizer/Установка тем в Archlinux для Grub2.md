############# Справка ##############
ArchWiki : https://wiki.archlinux.org/title/GRUB
Grub Customizer (grub-customizer) : https://launchpad.net/grub-customizer
### Установка тем в Archlinux для Grub2:
### Grub2 Theme Breeze
# Минималистичная тема GRUB, вдохновленная Breeze.
sudo pacman -Sy breeze-grub  # Тема Breeze для GRUB ; https://archlinux.org/packages/extra/any/breeze-grub/ ; https://kde.org/plasma-desktop/ ; https://store.kde.org/p/1000140/ ; https://github.com/gustawho/grub2-theme-breeze ; https://github.com/gustawho/grub2-theme-breeze.git ; 2025-07-15 18:36 UTC
### Grub2 Theme Vimix
sudo pacman -Sy grub-theme-vimix  # Размытая тема для grub ; https://archlinux.org/packages/extra/any/grub-theme-vimix/ ; https://github.com/kalax2/grub2-theme-vimix ; https://github.com/kalax2/grub2-theme-vimix.git ; Заменяет: vimix-grub ; 2024-08-26 14:52 UTC
После установки вам необходимо настроить GRUB, отредактировав файл конфигурации:
Откройте окно терминала.
Создайте резервную копию исходного файла конфигурации:
sudo cp /etc/default/grub /etc/default/grub.bak
Отредактируйте файл конфигурации с помощью текстового редактора, например nano:
sudo nano /etc/default/grub
Раскомментируйте « GRUB_GFXMODE» и установите желаемое разрешение (например, GRUB_GFXMODE=2560x1440,autoразрешение 2k).
Раскомментируйте « GRUB_THEME» и укажите путь к теме Breeze:
GRUB_THEME="/usr/share/grub/themes/breeze/theme.txt"
Обновление GRUB:
Archlinux и Ubuntu:
sudo grub-mkconfig -o /boot/grub/grub.cfg
Эта коллекция предлагает разнообразные чистые темы в современном стиле с размытыми элементами и фонами в стиле Material. Вы можете выбрать монохромные белые значки для более унифицированного оформления. Установка осуществляется с помощью скрипта, предоставленного автором темы:
Клонировать репозиторий:
git clone https://github.com/vinceliuice/grub2-themes.git
Перейдите в каталог:
cd grub2-themes
Запустите скрипт установки:
sudo ./install.sh
Копировать
Выберите желаемую тему, цвет значков и разрешение.
Скрипт автоматически применяет тему и обновляет файл конфигурации.
Vimix также доступен в репозитории Arch Extra ( sudo pacman -Sy grub-theme-vimix) и может применяться вручную, как Breeze.
https://github.com/kalax2/grub2-theme-vimix
https://archlinux.org/packages/extra/any/grub-theme-vimix/
https://github.com/kalax2/grub2-theme-vimix.git
Установка темы ручками
https://store.kde.org/p/1000140/
https://github.com/gustawho/grub2-theme-breeze
https://www.gnome-look.org/p/1000140
Скопируйте каталог "breeze" в папку, доступную GRUB. Стандартный путь — /usr/share/grub/themes/, но если вы устанавливаете тему в зашифрованной системе, вы можете скопировать содержимое этого пакета в папку /boot и соответствующим образом настроить файл конфигурации GRUB.
Отредактируйте /etc/default/grub, убедившись, что эта строка (или ее вариант) существует:
GRUB_THEME="/usr/share/grub/themes/breeze/theme.txt"
И затем выполните:
sudo grub-mkconfig -o /boot/grub/grub.cfg