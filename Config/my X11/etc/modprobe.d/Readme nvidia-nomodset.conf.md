Тиринг на видеокартах NVidia

https://vmblog.ru/tiringa-ekrana-v-linux/

Для исправления проблемы тиринга на видеокартах NVidia, создайте файл конфигурации в каталоге modprobe:

$ sudo nano /etc/modprobe.d/nvidia-nomodset.conf

Добавьте в файл строку:

options nvidia-drm modset=1

Сохраните файл и выполните:

$ sudo update-initramfs -u

Перезагрузите компьютер, и проверьте исчезли ли проблема с разрывами экрана. Если нет, отредактируйте файл 20-nvidia.conf:

$ sudo nano /etc/X11/xorg.conf.d/20-nvidia.conf

Добавьте следующее в секции Device:

Section "Device"

     
     
   Identifier "Nvidia Card"
   Driver "nvidia"
   VendorName "NVIDIA Corporation"
   Option "NoLogo" "true"
   Option      "metamodes"  "nvidia-auto-select +0+0 { ForceCompositionPipeline = On }"
EndSection