loadkeys ru
setfont cyr-sun16
clear
## Check if in live or chroot environment
## Проверьте, находится ли он в среде live или chroot
if [[ -z ${1-} ]]; then

	## Check boot mode
	## Проверьте режим загрузки

	if [[ -d /sys/firmware/efi ]]; then
		echo "UEFI mode detected!"
		IsUEFI="yes"
	else
		echo "BIOS mode detected!"
		IsUEFI="no"
	fi

	## CPU detection
	## Обнаружение центрального процессора
	if grep Intel /proc/cpuinfo; then
		IntelCPU="yes"
	else
		IntelCPU="no"
	fi

	echo "Here are the detected disks:"
	## Вот обнаруженные диски:
	lsblk -p | grep disk
	echo -e "\nType the disk you want to install ArchLinux (eg: /dev/sdX, /dev/vdX, /dev/nvme*nX): "
	## Введите диск, на который вы хотите установить Arch Linux (eg: /dev/sdX, /dev/vdX, /dev/nvme*nX):
	read disk
	if [[ $(lsblk -p | grep $disk) ]]; then
		echo "Correct disk!"
		## Правильный диск!
	else
		echo "Wrong disk selected!"
		## Выбран неправильный диск!
		exit
	fi

	echo -e "\nYou selected ${disk}, do you want to continue (Y/n)?"
	## Вы выбрали ${диск}, хотите ли вы продолжить (Y/n)?
	read ans

	if [[ $ans = "Y" ]]; then
		echo -e "\nContinuing.."
		## Продолжающийся..
	else
		echo -e "\nAborted!"
		## Прервано!
		exit
	fi

	echo -e "\nTwo partitions will be created:"
	## Будут созданы два раздела:
	if [[ $(lsblk | grep nvme) ]]; then
		ESP="${disk}p1"
		root="${disk}p2"
	else
		ESP="${disk}1"
		root="${disk}2"
	fi

	echo -e "${ESP}\tEFI system partition"
	echo -e "${root}\tRoot partition"

	echo -e "Do you want to continue (Y/n)? "
	## Вы хотите продолжить (Y/n)?
	read confirmation

	if [[ $confirmation = "Y" ]]; then
		echo "Continuing..."
		## Продолжающийся..
	else
		echo "Aborted!"
		## Прервано!
		exit
	fi
	clear

	# hostname, username, rootpassword, user password
	## имя хоста, имя пользователя, пароль root, пароль пользователя password
	echo -e "${Yellow}How would you like to name this computer?${NoColor}"
	## Как бы вы хотели назвать этот компьютер?
	read hostname; clear
	echo -e "${Yellow}What password should root(administrator) account have?${NoColor}"
	## Какой пароль должен быть у учетной записи root (администратора)?
	read rootpassword; clear
	echo -e "What username do you want?"
	## Какое имя пользователя вам нужно?
	read username; clear
	echo -e "What password should ${username} have?"
	## Какой пароль должен быть у юзера?
	read userpassword; clear
	echo -e "How much swap would you like for this install?"
	## Какой объем подкачки вы хотели бы получить для этой установки?
	read swap;
	echo -e "How much swappiness would you like for swap?"
	## Какую скорость обмена вы бы хотели получить при обмене?
	read swappiness; clear
	echo -e "Add any kernel parameters that you need. Separate them by space. (example: amdgpu.runpm=0, audit=1, vfio-pci.ids=1002:731f). Press enter to leave it blank."
	## Добавьте любые параметры ядра, которые вам нужны. Разделите их пробелом.
	## Нажмите enter, чтобы оставить поле пустым.
	read kparams; clear
	echo -e "Do you want to load vfio_pci early for GPU passthrough?"
	## Вы хотите загрузить vfio_pci заранее для прохождения через GPU?
	read gpupass; clear

	if lspci | grep Radeon >/dev/null; then
		echo -e "Do you want to install the AMDGPU driver (1 or 2)?\nSelect yes(1) if unsure. This script does not support very old AMD GPUs."
		## Хотите ли вы установить драйвер графического процессора AMD (1 или 2)?\выберите да(1), если не уверены. Этот скрипт не поддерживает очень старые графические процессоры AMD.
		select yn in "Yes" "No"; do
			case $yn in
				Yes ) answerAMD="yes"; break;;
				No ) answerAMD="no"; break;;
			esac
		done
		clear
	else
		answerAMD="no"; # No AMD card detected, setting no to satisfy strict mode.
	fi

	if [[ ${IntelCPU} == "yes" ]]; then # No point in asking with an AMD CPU
		echo -e "Do you want to install the xf86-video-intel driver (1 or 2)? Select yes(1) if this is a CPU with integrated GPU and is 3rd gen or older. The modesetting driver(default) is better for 4th gen and newer CPUs."
	## Хотите ли вы установить драйвер xf86-video-intel (1 или 2)? Выберите да(1), если это процессор со встроенным графическим процессором 3-го поколения или более ранней версии. Драйвер настройки режима (по умолчанию) лучше подходит для процессоров 4-го поколения и более новых версий.
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

	## Set system clock
	## Установка системных часов
	timedatectl set-ntp true

	## Partitioning
	## Разделение на разделы

	## Manual partition selection
	## Ручной выбор раздела

	#echo "Enter EFI partition label: "
	## Введите метку раздела EFI:
	#read EFIpartition;

	#echo "Enter ROOT partition label: "
	## Введите метку корневого раздела:
	#read ROOTpartition

	## Fully wipe and create fresh partitions
	## Полностью сотрите и создайте новые разделы

	## Create new GUID Partition Table
	## Создайте новую таблицу разделов GUID
	echo "Wiping drive.."
	wipefs -a ${disk}
	echo "Creating partition table.."
	parted -s ${disk} mklabel gpt
	echo "Creating ESP.."
	parted -s ${disk} mkpart ESP fat32 1MiB 513MiB
	parted -s ${disk} set 1 esp on
	echo "Creating root partition.."
	parted -s ${disk} mkpart ArchLinux ext4 513MiB 100%

	## Configure encryption
	## Настройка шифрования
	echo "Configuring encrypted container.."
	## Настройка зашифрованного контейнера..
	cryptsetup luksFormat ${root}
	echo "Opening container.."
	## Открываем контейнер..
	cryptsetup open ${root} cryptlvm
	echo "Create ArchGroup.."
	## Создайте группу Arch..
	pvcreate -ff /dev/mapper/cryptlvm
	vgcreate ArchGroup /dev/mapper/cryptlvm
	echo "Creating root logical volume.."
	## Создание корневого логического тома..
	lvcreate -l 100%FREE ArchGroup -n root
	echo "Creating FS for root volume.."
	## Создаем FS для корневого тома..
	mkfs.ext4 /dev/ArchGroup/root
	echo "Mounting root at /mnt.."
	## Установка root в /mnt..
	mount /dev/ArchGroup/root /mnt

	## Boot partition
	## Загрузочный раздел
	echo "Creating FS for /boot"
	## Создание FS для /boot
	mkfs.fat -F32 ${ESP}
	mkdir /mnt/boot
	echo "Mounting boot at /mnt/boot"
	## Установка загрузки по адресу /mnt/boot
	mount ${ESP} /mnt/boot
	clear

	## Mirrors
	## Зеркала
	echo "Updating mirrors.."
	## Обновление зеркал..
	reflector --latest 15 --sort rate --save /etc/pacman.d/mirrorlist
	clear

	## Change pacman.conf
	## Измените файл pacman.conf
	sed -i s/"#Color"/"Color"/g /etc/pacman.conf
	sed -i s/"#ParallelDownloads"/"ParallelDownloads"/g /etc/pacman.conf

	## Install base system
	## Установите базовую систему
	echo "Running pacstrap.."
	## Запуск pacstrap..
	pacstrap /mnt base base-devel linux linux-firmware lvm2 nano networkmanager ansible git zsh reflector python-pip python-virtualenv
	clear

	# Mirrors to installed system
	## Зеркалирование установленной системы
	cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist

	# Generate fstab
	## Сгенерировать fstab
	echo "Generating fstab.."
	## Генерируем fstab..
	genfstab -U /mnt >> /mnt/etc/fstab

	## copy script file to installed system
	## скопируйте файл скрипта в установленную систему
	cp ${BASH_SOURCE} /mnt/root

	## Declare variables in chroot
	## Объявляйте переменные в chroot
	declare -p disk root ESP IntelCPU answerINTEL answerAMD hostname username rootpassword userpassword swap swappiness kparams gpupass > /mnt/root/answerfile

	## Avoid broken keyring on a clean pacstrap
    ## Избегайте поломки брелка на чистом ремешке для ключей
	echo -e "${Yellow}Running keyring population to avoid broken keyring on a clean pacstrap${NoColor}" # https://t.me/archlinuxgroup/507931
	arch-chroot /mnt/archinstall /usr/bin/pacman-key --populate archlinux

	## arch-chroot
	echo "Chrooting into installed system and executing the install script.."
	## Выполняем рутинг в установленной системе и запускаем установочный скрипт..
	arch-chroot /mnt /bin/bash -c "/root/$(basename $BASH_SOURCE) mendacity"
	clear
else
	## Get variables from answerfile
	## Получение переменных из файла ответов
	source /root/answerfile

	# Create swap file
	## Создать файл подкачки
	echo "Creating swap file.."
	dd if=/dev/zero of=/swapfile bs=1M count=${swap} status=progress
	chmod 600 /swapfile
	mkswap /swapfile
	swapon /swapfile
	echo "/swapfile none swap defaults 0 0" >> /etc/fstab

	# Configuring swappiness
	## Настройка возможности замены
	echo "Configuring swappiness.."
	echo "vm.swappiness=${swappiness}" > /etc/sysctl.d/99-swappiness.conf

	## Setting basic system
	## Настройка базовой системы
	echo "Setting time.."
	## Время установки..
	ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
	hwclock --systohc

	echo "Setting locale.."
	## Настройка языкового стандарта..
	sed -i s/#en_US.UTF-8/en_US.UTF-8/g /etc/locale.gen
	localectl set-locale LANG=en_US.UTF-8
	locale-gen

	echo "Setting keymap.."
	## Настройка раскладки клавиш..
	echo "KEYMAP=us" > /etc/vconsole.conf

	echo "Setting hostname.."
	## Установка имени хоста..
	echo "${hostname}" > /etc/hostname

	echo "Setting hosts.."
	## Настройка хостов..
	echo "127.0.0.1	localhost" >> /etc/hosts
	echo "::1 localhost" >> /etc/hosts
	echo "127.0.1.1	${hostname}" >> /etc/hosts

	## Configure mkinitcpio
	## NOTE: These commands won't work on zsh because of command substitution
	## Настройте mkinitcpio
	## ПРИМЕЧАНИЕ: Эти команды не будут работать в zsh из-за замены команд
	echo "Setting up mkinitcpio.."
	## Настройка mkinitcpio..
	# For loading GPU passthrough modules early, also needs kernel parameter. For G5SE use: vfio-pci.ids=1002:731f
	## Для ранней загрузки модулей GPU passthrough также требуется параметр ядра. Для G5 SE используйте: vfio-pci.ids=1002:731 f
	defaultModules="MODULES=()"
	modules="MODULES=(vfio_pci vfio vfio_iommu_type1)"
	# For disk encryption
	## Для шифрования диска
	encryptHooks="HOOKS=(base systemd autodetect keyboard sd-vconsole modconf block sd-encrypt lvm2 filesystems fsck)"
	defaultHooks="HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont block filesystems fsck)"

	if [[ ${gpupass} == "yes" ]]; then
		sed -i s/"${defaultModules}"/"${modules}"/ /etc/mkinitcpio.conf
	else
		echo "Not loading vfio_pci early."
	fi

	sed -i s/"${defaultHooks}"/"${encryptHooks}"/ /etc/mkinitcpio.conf
	mkinitcpio -p linux

	## root password
	## пароль root
	echo "Setting root password.."
	echo "root:${rootpassword}" | chpasswd

	# Install CPU microcode based on which CPU was detected.
	# --overwrite in case ucode was previously already installed
	## Установите микрокод процессора на основе того, какой процессор был обнаружен.
	## --перезаписать, если ранее ucode уже был установлен
	echo -e "Installing CPU microcode.."
	## Установка микрокода центрального процессора..
	if [[ ${IntelCPU} == "yes" ]]; then
		pacman -Syu intel-ucode --noconfirm --overwrite='/boot/intel-ucode.img'
	else
		pacman -Syu amd-ucode --noconfirm --overwrite='/boot/amd-ucode.img'
	fi

	##Bootloader
	## Загрузчик операционной системы
	echo "Install bootloader.."
	## Установите загрузчик..
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

	#Enable network manager
	## Включить сетевой менеджер
	echo "Enabling NetworkManager.."
	systemctl enable NetworkManager.service
	clear

	#GPU drivers
	## Драйверы графического процессора
	if [[ ${answerINTEL} == "yes" ]]; then
		pacman -S --noconfirm xf86-video-intel
	elif [[ ${answerAMD} == "yes" ]]; then
		pacman -S --noconfirm xf86-video-amdgpu
	fi

	#Create User
	## Создать пользователя
	echo "Creating and setting up user.."
	## Создание и настройка пользователя..
	useradd -m -s /bin/zsh ${username}
	echo "${username}:${userpassword}" | chpasswd
	echo "${username} ALL=(ALL:ALL) ALL" >> /etc/sudoers
	clear

	exit
fi

clear
#Success
## Успех
echo "Installation complete! Reboot."
## Установка завершена! Перезагрузить.
