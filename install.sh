## Check if in live or chroot environment
if [[ -z ${1-} ]]; then

	## Check boot mode

	if [[ -d /sys/firmware/efi ]]; then
		echo "UEFI mode detected!"
		IsUEFI="yes"
	else
		echo "BIOS mode detected!"
		IsUEFI="no"
	fi

	## CPU detection
	if grep Intel /proc/cpuinfo; then
		IntelCPU="yes"
	else
		IntelCPU="no"
	fi

	echo "Here are the detected disks:"
	lsblk -p | grep disk
	echo -e "\nType the disk you want to install ArchLinux (eg: /dev/sdX, /dev/vdX, /dev/nvme*nX): "
	read disk
	if [[ $(lsblk -p | grep $disk) ]]; then
		echo "Correct disk!"
	else
		echo "Wrong disk selected!"
		exit
	fi

	echo -e "\nYou selected ${disk}, do you want to continue (Y/n)?"
	read ans

	if [[ $ans = "Y" ]]; then
		echo -e "\nContinuing.."
	else
		echo -e "\nAborted!"
		exit
	fi

	echo -e "\nTwo partitions will be created:"
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
	read confirmation

	if [[ $confirmation = "Y" ]]; then
		echo "Continuing..."
	else
		echo "Aborted!"
		exit
	fi
	clear

	# hostname, username, rootpassword, user password
	echo -e "${Yellow}How would you like to name this computer?${NoColor}"
	read hostname; clear
	echo -e "${Yellow}What password should root(administrator) account have?${NoColor}"
	read rootpassword; clear
	echo -e "What username do you want?"
	read username; clear
	echo -e "What password should ${username} have?"
	read userpassword; clear
	echo -e "How much swap would you like for this install?"
	read swap;
	echo -e "How much swappiness would you like for swap?"
	read swappiness; clear
	echo -e "Add any kernel parameters that you need. Separate them by space. (example: amdgpu.runpm=0, audit=1, vfio-pci.ids=1002:731f). Press enter to leave it blank."
	read kparams; clear
	echo -e "Do you want to load vfio_pci early for GPU passthrough?"
	read gpupass; clear

	if lspci | grep Radeon >/dev/null; then
		echo -e "Do you want to install the AMDGPU driver (1 or 2)?\nSelect yes(1) if unsure. This script does not support very old AMD GPUs."
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
	timedatectl set-ntp true

	## Partitioning

	## Manual partition selection

	#echo "Enter EFI partition label: "
	#read EFIpartition;

	#echo "Enter ROOT partition label: "
	#read ROOTpartition

	## Fully wipe and create fresh partitions

	## Create new GUID Partition Table
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
	echo "Configuring encrypted container.."
	cryptsetup luksFormat ${root}
	echo "Opening container.."
	cryptsetup open ${root} cryptlvm
	echo "Create ArchGroup.."
	pvcreate -ff /dev/mapper/cryptlvm
	vgcreate ArchGroup /dev/mapper/cryptlvm
	echo "Creating root logical volume.."
	lvcreate -l 100%FREE ArchGroup -n root
	echo "Creating FS for root volume.."
	mkfs.ext4 /dev/ArchGroup/root
	echo "Mounting root at /mnt.."
	mount /dev/ArchGroup/root /mnt

	## Boot partition
	echo "Creating FS for /boot"
	mkfs.fat -F32 ${ESP}
	mkdir /mnt/boot
	echo "Mounting boot at /mnt/boot"
	mount ${ESP} /mnt/boot
	clear

	## Mirrors
	echo "Updating mirrors.."
	reflector --latest 15 --sort rate --save /etc/pacman.d/mirrorlist
	clear

	## Change pacman.conf
	sed -i s/"#Color"/"Color"/g /etc/pacman.conf
	sed -i s/"#ParallelDownloads"/"ParallelDownloads"/g /etc/pacman.conf

	## Install base system
	echo "Running pacstrap.."
	pacstrap /mnt base base-devel linux linux-firmware lvm2 nano networkmanager ansible git zsh reflector python-pip python-virtualenv
	clear

	# Mirrors to installed system
	cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist

	# Generate fstab
	echo "Generating fstab.."
	genfstab -U /mnt >> /mnt/etc/fstab

	## copy script file to installed system
	cp ${BASH_SOURCE} /mnt/root

	## Declare variables in chroot
	declare -p disk root ESP IntelCPU answerINTEL answerAMD hostname username rootpassword userpassword swap swappiness kparams gpupass > /mnt/root/answerfile

	## Avoid broken keyring on a clean pacstrap
	echo -e "${Yellow}Running keyring population to avoid broken keyring on a clean pacstrap${NoColor}" # https://t.me/archlinuxgroup/507931
	arch-chroot /mnt/archinstall /usr/bin/pacman-key --populate archlinux

	## arch-chroot
	echo "Chrooting into installed system and executing the install script.."
	arch-chroot /mnt /bin/bash -c "/root/$(basename $BASH_SOURCE) mendacity"
	clear
else
	## Get variables from answerfile
	source /root/answerfile

	# Create swap file
	echo "Creating swap file.."
	dd if=/dev/zero of=/swapfile bs=1M count=${swap} status=progress
	chmod 600 /swapfile
	mkswap /swapfile
	swapon /swapfile
	echo "/swapfile none swap defaults 0 0" >> /etc/fstab

	# Configuring swappiness
	echo "Configuring swappiness.."
	echo "vm.swappiness=${swappiness}" > /etc/sysctl.d/99-swappiness.conf

	## Setting basic system
	echo "Setting time.."
	ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
	hwclock --systohc

	echo "Setting locale.."
	sed -i s/#en_US.UTF-8/en_US.UTF-8/g /etc/locale.gen
	localectl set-locale LANG=en_US.UTF-8
	locale-gen

	echo "Setting keymap.."
	echo "KEYMAP=us" > /etc/vconsole.conf

	echo "Setting hostname.."
	echo "${hostname}" > /etc/hostname

	echo "Setting hosts.."
	echo "127.0.0.1	localhost" >> /etc/hosts
	echo "::1 localhost" >> /etc/hosts
	echo "127.0.1.1	${hostname}" >> /etc/hosts

	## Configure mkinitcpio
	## NOTE: These commands won't work on zsh because of command substitution
	echo "Setting up mkinitcpio.."
	# For loading GPU passthrough modules early, also needs kernel parameter. For G5SE use: vfio-pci.ids=1002:731f
	defaultModules="MODULES=()"
	modules="MODULES=(vfio_pci vfio vfio_iommu_type1)"
	# For disk encryption
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
	echo "Setting root password.."
	echo "root:${rootpassword}" | chpasswd

	# Install CPU microcode based on which CPU was detected.
	# --overwrite in case ucode was previously already installed
	echo -e "Installing CPU microcode.."
	if [[ ${IntelCPU} == "yes" ]]; then
		pacman -Syu intel-ucode --noconfirm --overwrite='/boot/intel-ucode.img'
	else
		pacman -Syu amd-ucode --noconfirm --overwrite='/boot/amd-ucode.img'
	fi

	##Bootloader
	echo "Install bootloader.."
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
	echo "Enabling NetworkManager.."
	systemctl enable NetworkManager.service
	clear

	#GPU drivers
	if [[ ${answerINTEL} == "yes" ]]; then
		pacman -S --noconfirm xf86-video-intel
	elif [[ ${answerAMD} == "yes" ]]; then
		pacman -S --noconfirm xf86-video-amdgpu
	fi

	#Create User
	echo "Creating and setting up user.."
	useradd -m -s /bin/zsh ${username}
	echo "${username}:${userpassword}" | chpasswd
	echo "${username} ALL=(ALL:ALL) ALL" >> /etc/sudoers
	clear

	exit
fi

clear
#Success
echo "Installation complete! Reboot."
