Nvidia optimus screen tearing fix for Arch.

https://gist.github.com/coenraadhuman/1155be9ad42cb27c63ebc0cc10e95f04

nvidia-optimus-screen-tearing-fix-arch.sh

sudo touch /etc/modprobe.d/zz-nvidia-modeset.conf
sudo echo "options nvidia_drm modeset=1" > /etc/modprobe.d/zz-nvidia-modeset.conf

echo "Where XY is the name of the kernel, for example linux419."
echo "..."
echo "Run the following command:"
echo "mkinitcpio -p linuxXY"