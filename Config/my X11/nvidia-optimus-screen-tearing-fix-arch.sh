sudo touch /etc/modprobe.d/zz-nvidia-modeset.conf
sudo echo "options nvidia_drm modeset=1" > /etc/modprobe.d/zz-nvidia-modeset.conf

echo "Where XY is the name of the kernel, for example linux419."
echo "..."
echo "Run the following command:"
echo "mkinitcpio -p linuxXY"