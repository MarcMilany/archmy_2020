loadkeys ru
setfont cyr-sun16
clear
echo ""
## Check if in live or chroot environment
echo "Проверьте, находится ли он в среде live или chroot"

if [[ -z ${1-} ]]; then

	echo "Проверьте режим загрузки"
    ## Check boot mode
	if [[ -d /sys/firmware/efi ]]; then
		echo "UEFI mode detected!"
		IsUEFI="yes"
	else
		echo "BIOS mode detected!"
		IsUEFI="no"
	fi

	
	echo "Обнаружение центрального процессора"
    ## CPU detection
	if grep Intel /proc/cpuinfo; then
		IntelCPU="yes"
	else
		IntelCPU="no"
	fi

	echo "Вот обнаруженные диски"
	## Here are the detected disks:
	lsblk -p | grep disk
	echo -e "\nВведите диск, на который вы хотите установить Arch Linux (eg: /dev/sdX, /dev/vdX, /dev/nvme*nX): " 
	## Type the disk you want to install ArchLinux (eg: /dev/sdX, /dev/vdX, /dev/nvme*nX):
	read disk
	if [[ $(lsblk -p | grep $disk) ]]; then
		echo "Правильный диск!"
		## Correct disk!
	else
		echo "Выбран неправильный диск!"
		## Wrong disk selected!
		exit
	fi

	echo -e "\nВы выбрали ${disk}, хотите ли вы продолжить (Y/n)?"
	## You selected ${disk}, do you want to continue (Y/n)?
	read ans

	if [[ $ans = "Y" ]]; then
		echo -e "\nПродолжающийся.."
		## Continuing..
	else
		echo -e "\nПрервано!"
		## Aborted!
		exit
	fi

	echo -e "\nБудут созданы два раздела:"
	## Two partitions will be created:
	if [[ $(lsblk | grep nvme) ]]; then
		ESP="${disk}p1"
		root="${disk}p2"
	else
		ESP="${disk}1"
		root="${disk}2"
	fi

	echo -e "${ESP}\tEFI системный раздел"
	## EFI system partition
	echo -e "${root}\tRoot раздел"
	## Root partition

	echo -e "Вы хотите продолжить (Y/n)?"
	## Do you want to continue (Y/n)? 
	read confirmation

	if [[ $confirmation = "Y" ]]; then
		echo "Продолжающийся..."
		## Continuing...
	else
		echo "Прервано!"
		## Aborted!
		exit
	fi
	clear
    
    # hostname, username, rootpassword, user password
    echo ""
    echo "Имя хоста, имя пользователя, пароль root, пароль пользователя password"
    echo ""
	echo -e "${Yellow}Как бы вы хотели назвать этот компьютер?${NoColor}"
	## How would you like to name this computer?
	read hostname; clear
	echo -e "${Yellow}Какой пароль должен быть у учетной записи root (администратора)?${NoColor}"
	## What password should root(administrator) account have?
	read rootpassword; clear
	echo -e "Какое имя пользователя вам нужно?"
	## What username do you want?
	read username; clear
	echo -e "Какой пароль должен быть у юзера ${username}?"
	## What password should ${username} have?
	read userpassword; clear
	echo -e "Какой объём подкачки вы хотели бы получить для этой установки?"
	## How much swap would you like for this install?
	read swap;
	echo -e "Какую скорость обмена вы бы хотели получить при обмене?"
	## How much swappiness would you like for swap?
	read swappiness; clear
	echo -e "Добавьте любые параметры ядра, которые вам нужны. Разделите их пробелом. (example: amdgpu.runpm=0, audit=1, vfio-pci.ids=1002:731f). Нажмите enter, чтобы оставить поле пустым."
	## Add any kernel parameters that you need. Separate them by space. (example: amdgpu.runpm=0, audit=1, vfio-pci.ids=1002:731f).
	## Press enter to leave it blank.
	read kparams; clear
	echo -e "Вы хотите загрузить vfio_pci заранее для прохождения через GPU?"
	## Do you want to load vfio_pci early for GPU passthrough?
	read gpupass; clear

	if lspci | grep Radeon >/dev/null; then
		echo -e "Хотите ли вы установить драйвер графического процессора AMD (1 или 2)?\nВыберите да(1), если не уверены. Этот скрипт не поддерживает очень старые графические процессоры AMD."
		## Do you want to install the AMDGPU driver (1 or 2)?\nSelect yes(1) if unsure. This script does not support very old AMD GPUs.
		select yn in "Yes" "No"; do
			case $yn in
				Yes ) answerAMD="yes"; break;;
				No ) answerAMD="no"; break;;
			esac
		done
		clear
	else
		answerAMD="no"; # No AMD card detected, setting no to satisfy strict mode.(Карта AMD не обнаружена, установите значение "нет" для соответствия строгому режиму)
	fi

	if [[ ${IntelCPU} == "yes" ]]; then # No point in asking with an AMD CPU.(Нет смысла спрашивать об этом с процессором AMD)
		echo -e "Хотите ли вы установить драйвер xf86-video-intel (1 или 2)? Выберите да(1), если это процессор со встроенным графическим процессором 3-го поколения или более ранней версии. Драйвер настройки режима (по умолчанию) лучше подходит для процессоров 4-го поколения и более новых версий."   
	## Do you want to install the xf86-video-intel driver (1 or 2)? Select yes(1) if this is a CPU with integrated GPU and is 3rd gen or older. The modesetting driver(default) is better for 4th gen and newer CPUs.
		select yn in "Yes" "No"; do
			case $yn in
				Yes ) answerINTEL="yes"; break;;
				No ) answerINTEL="no"; break;;
			esac
		done
		clear
	else
		answerINTEL="no"; # No Intel CPU detected, setting no to satisfy strict mode.
	fi

	echo "Установка системных часов" 
	## Set system clock
	timedatectl set-ntp true
    
    echo "Разделение на разделы" 
	## Partitioning

	## Manual partition selection
	## Ручной выбор раздела

	#echo "Enter EFI partition label: "
	## Введите метку раздела EFI:
	#read EFI раздел;
	#read EFIpartition;

    #echo "Введите метку корневого раздела: "
	#echo "Enter ROOT partition label: "
	 
	#read ROOT раздел
	#read ROOTpartition

	## Полностью сотрите и создайте новые разделы 
	## Fully wipe and create fresh partitions

	## Создайте новую таблицу разделов GUID
	## Create new GUID Partition Table 
    echo "Очистка диска.."
	#echo "Wiping drive.."
	wipefs -a ${disk}
    echo "Создаём таблицу разделов.."
	#echo "Creating partition table.."
	parted -s ${disk} mklabel gpt
	#parted -s ${disk} mklabel msdos
	echo "Создание ESP.."
	#echo "Creating ESP.."
	parted -s ${disk} mkpart ESP fat32 1MiB 513MiB
	parted -s ${disk} set 1 esp on
	echo "Создаем root раздел.."
	#echo "Creating root partition.."
	parted -s ${disk} mkpart ArchLinux ext4 513MiB 100%

	## Настройка шифрования 
	## Configure encryption
    echo "Настройка зашифрованного контейнера.."
	#echo "Configuring encrypted container.."
	cryptsetup luksFormat ${root}
	echo "Открываем контейнер.."
	#echo "Opening container.."
	cryptsetup open ${root} cryptlvm
	echo "Создайте группу Arch.."
	#echo "Create ArchGroup.."
	pvcreate -ff /dev/mapper/cryptlvm
	vgcreate ArchGroup /dev/mapper/cryptlvm
	echo "Создание root логического тома.."
	#echo "Creating root logical volume.."
	lvcreate -l 100%FREE ArchGroup -n root
	echo "Создаем FS для корневого тома.."
	#echo "Creating FS for root volume.."
	mkfs.ext4 /dev/ArchGroup/root
	echo "Установка root в /mnt.."
	#echo "Mounting root at /mnt.."
	mount /dev/ArchGroup/root /mnt
    
    echo "Загрузочный раздел..."
	## Boot partition...
    echo "Создание FS для /boot"
	#echo "Creating FS for /boot"
	mkfs.fat -F32 ${ESP}
	mkdir /mnt/boot
	echo "Монтаж boot по адресу /mnt/boot"
	#echo "Mounting boot at /mnt/boot"
	mount ${ESP} /mnt/boot
	clear

	## Зеркала
	## Mirrors
	echo "Обновление зеркал.."
	#echo "Updating mirrors.."
	reflector --latest 15 --sort rate --save /etc/pacman.d/mirrorlist
	clear

	echo "Измените файл pacman.conf.."
	#echo "Change pacman.conf.."
	sed -i s/"#Color"/"Color"/g /etc/pacman.conf
	sed -i s/"#ParallelDownloads"/"ParallelDownloads"/g /etc/pacman.conf
    
    echo "Установите базовую систему.."
    #echo "Install base system.."
	echo "Запуск pacstrap.."
	#echo "Running pacstrap.."
	pacstrap /mnt base base-devel linux linux-firmware lvm2 nano networkmanager ansible git zsh reflector python-pip python-virtualenv
	clear
    
    echo "Зеркала для установленной системы.."
	#echo "Mirrors to installed system.."
	cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist

	# Сгенерировать fstab 
	## Generate fstab
	echo "Генерируем fstab.."
	#echo "Generating fstab.."
	genfstab -U /mnt >> /mnt/etc/fstab

	## Copy script file to installed system
	## Скопируем файл скрипта в установленную систему
	cp ${BASH_SOURCE} /mnt/root
    
    echo "Объявляем переменные в chroot.."
    #echo "Declare variables in chroot.."
	declare -p disk root ESP IntelCPU answerINTEL answerAMD hostname username rootpassword userpassword swap swappiness kparams gpupass > /mnt/root/answerfile
    
    echo "Избегайте поломки брелка на чистом ремешке для ключей.."
    #echo "Avoid broken keyring on a clean pacstrap.."
	## Running keyring population to avoid broken keyring on a clean pacstrap
	echo -e "${Yellow}Запуск набора брелоков для ключей, чтобы избежать поломки брелока на чистом ремешке pacstrap${NoColor}" # https://t.me/archlinuxgroup/507931
	arch-chroot /mnt/archinstall /usr/bin/pacman-key --populate archlinux

	## arch-chroot
	echo "Выполняем Chrooting в установленной системе и запускаем установочный скрипт.."
	#echo "Chrooting into installed system and executing the install script.."
	arch-chroot /mnt /bin/bash -c "/root/$(basename $BASH_SOURCE) mendacity"
	clear
else
	echo "Получение переменных из файла ответов.."
	#echo "Get variables from answerfile.."
	source /root/answerfile

	echo "Создать файл подкачки (swap).."
	#echo "Creating swap file.."
	dd if=/dev/zero of=/swapfile bs=1M count=${swap} status=progress
	chmod 600 /swapfile
	mkswap /swapfile
	swapon /swapfile
	echo "/swapfile none swap defaults 0 0" >> /etc/fstab
    
    echo "Формирование swappiness.."
	#echo "Configuring swappiness.."
	echo "vm.swappiness=${swappiness}" > /etc/sysctl.d/99-swappiness.conf
    
    echo "Настройка базовой системы.."
    #echo "Setting basic system.."
	echo "Настройка времени.."
	#echo "Setting time.."
	ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
	#ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
	hwclock --systohc
    
    echo "Настройка локализации (язык)..."
	#echo "Setting locale.."
	sed -i s/#en_US.UTF-8/en_US.UTF-8/g /etc/locale.gen
	#sed -i s/#ru_RU.UTF-8/ru_RU.UTF-8/g /etc/locale.gen
	sed -i s/#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/g /etc/locale.gen
	#localectl set-locale LANG=en_US.UTF-8
	localectl set-locale LANG=ru_RU.UTF-8
	locale-gen

    echo "Указываем язык системы"
    echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf
    #echo 'LANG="en_US.UTF-8"' > /etc/locale.conf
    echo "LC_COLLATE=C" >> /etc/locale.conf
    echo 'LC_ADDRESS="ru_RU.UTF-8"' >> /etc/locale.conf
    echo 'LC_IDENTIFICATION="ru_RU.UTF-8"' >> /etc/locale.conf
    echo 'LC_MEASUREMENT="ru_RU.UTF-8"' >> /etc/locale.conf
    echo 'LC_MONETARY="ru_RU.UTF-8"' >> /etc/locale.conf
    echo 'LC_MESSAGES="ru_RU.UTF-8"' >> /etc/locale.conf
    echo 'LC_NAME="ru_RU.UTF-8"' >> /etc/locale.conf
    echo '#LC_CTYPE="ru_RU.UTF-8"' >> /etc/locale.conf
    echo 'LC_NUMERIC="ru_RU.UTF-8"' >> /etc/locale.conf
    echo 'LC_PAPER="ru_RU.UTF-8"' >> /etc/locale.conf
    echo 'LC_TELEPHONE="ru_RU.UTF-8"' >> /etc/locale.conf
    echo 'LC_TIME="ru_RU.UTF-8"' >> /etc/locale.conf

    echo "Проверяем, что все заявленные локали были созданы:"
    locale -a  # Смотрим какте локали были созданы
    sleep 1

	echo "Настройка раскладки клавиатуры.."
	#echo "Setting keymap.." 
	echo "KEYMAP=us" > /etc/vconsole.conf
    echo 'KEYMAP=ru' >> /etc/vconsole.conf
    echo '#LOCALE=ru_RU.UTF-8' >> /etc/vconsole.conf
    ## Шрифт с поддержкой кирилицы
    echo 'FONT=cyr-sun16' >> /etc/vconsole.conf
    echo '#FONT=ter-v16n' >> /etc/vconsole.conf
    echo '#FONT=ter-v16b' >> /etc/vconsole.conf
    echo '#FONT=ter-u16b' >> /etc/vconsole.conf
    echo 'FONT_MAP=' >> /etc/vconsole.conf
    echo '#CONSOLEFONT="cyr-sun16' >> /etc/vconsole.conf
    echo 'CONSOLEMAP=' >> /etc/vconsole.conf
    echo '#TIMEZONE=Europe/Moscow' >> /etc/vconsole.conf
    echo '#HARDWARECLOCK=UTC' >> /etc/vconsole.conf
    echo '#HARDWARECLOCK=localtime' >> /etc/vconsole.conf
    echo '#USECOLOR=yes' >> /etc/vconsole.conf
    echo 'COMPRESSION="lz4"' >> /etc/mkinitcpio.conf
    #echo 'COMPRESSION="xz"' >> /etc/mkinitcpio.conf
    echo "vboxdrv" > /etc/modules-load.d/virtualbox.conf
    ###
    ## Список всех доступных русских раскладок клавиатуры
    # ls /usr/share/kbd/keymaps/i386/qwerty/ru*
    ## Русская раскладка с переключением по Alt+Shift
    #echo 'KEYMAP="ruwin_alt_sh-UTF-8"' > /etc/vconsole.conf
    ## аналогично вызову
    # localectl set-keymap ruwin_alt_sh-UTF-8
    #######################

	echo "Установка имени хоста.."
	#echo "Setting hostname.."
	echo "${hostname}" > /etc/hostname

	echo "Настройка хостов файла hosts.."
	#echo "Setting hosts.."
	echo "127.0.0.1	localhost.(none)" > /etc/hosts
	#echo "127.0.0.1	localhost" >> /etc/hosts
	echo "::1 localhost" >> /etc/hosts
	echo "127.0.1.1	${hostname}" >> /etc/hosts
    echo "::1	localhost ip6-localhost ip6-loopback" >> /etc/hosts
    echo "ff02::1 ip6-allnodes" >> /etc/hosts
    echo "ff02::2 ip6-allrouters" >> /etc/hosts




    echo "Конфигурировать mkinitcpio.."
	#echo "Configure mkinitcpio.."
	echo "ПРИМЕЧАНИЕ: Эти команды не будут работать в zsh из-за замены команд!.."
    #echo "NOTE: These commands won't work on zsh because of command substitution!.."
	echo "Настройка mkinitcpio.."
	#echo "Setting up mkinitcpio.."
	echo "Для ранней загрузки модулей GPU passthrough также требуется параметр ядра. Для G5SE используйте: vfio-pci.ids=1002:731f.."
	#echo "For loading GPU passthrough modules early, also needs kernel parameter. For G5SE use: vfio-pci.ids=1002:731f.."
	defaultModules="MODULES=()"
	modules="MODULES=(vfio_pci vfio vfio_iommu_type1)"
	echo "Для шифрования диска.."
	#echo "For disk encryption.."
	encryptHooks="HOOKS=(base systemd autodetect keyboard sd-vconsole modconf block sd-encrypt lvm2 filesystems fsck)"
	defaultHooks="HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont block filesystems fsck)"

	if [[ ${gpupass} == "yes" ]]; then
		sed -i s/"${defaultModules}"/"${modules}"/ /etc/mkinitcpio.conf
	else
		echo "Not loading vfio_pci early."
	fi

	sed -i s/"${defaultHooks}"/"${encryptHooks}"/ /etc/mkinitcpio.conf
	mkinitcpio -p linux
    
    echo "Пароль root.."
    echo "Root password.."
	echo "Установка пароля root.."
	#echo "Setting root password.."
	echo "root:${rootpassword}" | chpasswd
    
    echo "Установите микрокод процессора на основе того, какой процессор был обнаружен..."
    echo "--перезаписать, если ранее ucode уже был установлен"
    #echo "Install CPU microcode based on which CPU was detected..."
    #echo "--overwrite in case ucode was previously already installed"
	echo -e "Установка микрокода центрального процессора (CPU microcode).."
	#echo -e "Installing CPU microcode.."
	if [[ ${IntelCPU} == "yes" ]]; then
		pacman -Syu intel-ucode --noconfirm --overwrite='/boot/intel-ucode.img'
	else
		pacman -Syu amd-ucode --noconfirm --overwrite='/boot/amd-ucode.img'
	fi
    
    echo "Загрузчик операционной системы (bootloader).."
    #echo "Bootloader.."
	echo "Установите загрузчик (bootloader).."
	#echo "Install bootloader.."
	bootctl install --graceful
	echo "Adding bootloader entry.."
	echo "title Arch Linux" > /boot/loader/entries/arch.conf
	echo "linux /vmlinuz-linux" >> /boot/loader/entries/arch.conf
	if [[ ${IntelCPU} == "yes" ]]; then
		echo "initrd /intel-ucode.img" >> /boot/loader/entries/arch.conf
	else
		echo "initrd /amd-ucode.img" >> /boot/loader/entries/arch.conf
	fi
	echo "initrd /initramfs-linux.img" >> /boot/loader/entries/arch.conf
	echo "options rd.luks.name=$(blkid -s UUID -o value ${root})=cryptlvm root=/dev/ArchGroup/root rw $kparams" >> /boot/loader/entries/arch.conf
    
    echo "Включить сетевой менеджер.."
    #echo "Enable network manager.."
	echo "Enabling NetworkManager.."
	systemctl enable NetworkManager.service
	clear
    
    echo "Драйверы графического процессора (GPU drivers).."
    #echo "GPU drivers.."
	if [[ ${answerINTEL} == "yes" ]]; then
		pacman -S --noconfirm xf86-video-intel
	elif [[ ${answerAMD} == "yes" ]]; then
		pacman -S --noconfirm xf86-video-amdgpu
	fi
    
	echo "Создать пользователя.."
	#echo "Create User.."
	echo "Создание и настройка пользователя.."
	#echo "Creating and setting up user.."
	useradd -m -s /bin/zsh ${username}
	echo "${username}:${userpassword}" | chpasswd
	echo "${username} ALL=(ALL:ALL) ALL" >> /etc/sudoers
	clear

	cp /etc/pacman.conf /etc/pacman.conf.backup  # Всегда, сначала сделайте резервную копию вашего pacman.config файла
    # cp -v /etc/pacman.conf /etc/pacman.conf.bkp  # -v или --verbose -Выводить информацию о каждом файле, который обрабатывает команда cp.
    echo " Раскрашивание вывода pacman и pacman easter egg (меняет индикатор выполнения на Pac-Man) "
    ### Color - Автоматически включать цвета только тогда, когда вывод pacman на tty.
    sed -i 's/#Color/Color/' /etc/pacman.conf  # Чтобы раскрасить вывод pacman, раскомментируем в /etc/pacman.conf строчку Color
    # sed -i '/#Color/ s/^#//' /etc/pacman.conf
    ### ILoveCandy - Потому что Pac-Man любит конфеты.
    sed -i '/^Co/ aILoveCandy' /etc/pacman.conf  # pacman easter egg (меняет индикатор выполнения на Pac-Man)
    # sed -i 's/VerbosePkgLists/VerbosePkgLists\nILoveCandy/g' /etc/pacman.conf
    ### Второй способ:  --(Но)!!!
    ## sed -i 's/VerbosePkgLists/VerbosePkgLists\nILoveCandy/g' /etc/pacman.conf
    ## sudo sed -i '/^\#VerbosePkgLists/aILoveCandy' /etc/pacman.conf  # pacman progress indicator
    ## sed -i 's/#Color/Color/g' /etc/pacman.conf  # pacman colors
    ### VerbosePkgLists - Отображает имя, версию и размер целевых пакетов в виде таблицы для операций обновления, синхронизации и удаления.
    sed -i 's/#VerbosePkgLists/VerbosePkgLists\n/g' /etc/pacman.conf
    ### Параллельная загрузка pacman (ParallelDownloads = ...)
    ### Указывает количество одновременных потоков загрузки. Значение должно быть положительным целым числом. Если этот параметр конфигурации не установлен, то используется только один поток загрузки (т.е. загрузки происходят последовательно).
    # ParallelDownloads = 5
    sed -i 's/#ParallelDownloads/ParallelDownloads/g' /etc/pacman.conf
    ### MultiLib (Include= /path/to/config/file) - Этот файл может включать репозитории или общие параметры конфигурации.
    sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
    clear

	exit
fi

clear

# Успех
#Success
echo "Установка завершена! Перезагрузить."
#echo "Installation complete! Reboot."

