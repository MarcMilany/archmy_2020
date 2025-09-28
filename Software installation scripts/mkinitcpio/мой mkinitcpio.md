# if you have more than 1 btrfs drive
# sed -i 's/^HOOKS/HOOKS=(base systemd autodetect modconf block sd-encrypt resume btrfs filesystems keyboard fsck)/' mkinitcpio.conf
# else
# если у вас более 1 диска BTRFS
# sed -i 's/^HOOKS/HOOKS=(base systemd autodetect modconf block sd-encrypt resume btrfs filesystems keyboard fsck)/' mkinitcpio.conf
# еще
sed -i 's/^HOOKS/HOOKS=(base systemd autodetect modconf block sd-encrypt resume filesystems keyboard fsck)/' mkinitcpio.conf

# sed -i 's/^HOOKS/HOOKS=(     resume btrfs )/' mkinitcpio.conf


# если у вас более 1 диска BTRFS
# sed -i 's/^HOOKS/HOOKS=(base udev autodetect microcode plymouth modconf kms keyboard keymap consolefont block resume btrfs filesystems fsck systemd)/' mkinitcpio.conf


мой mkinitcpio
HOOKS=(base udev autodetect microcode plymouth modconf kms keyboard keymap consolefont block resume btrfs filesystems fsck systemd)


mkinitcpio (Русский)
https://wiki.archlinux.org/title/Mkinitcpio_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)