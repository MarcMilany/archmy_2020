Отключить pulseaudio:
https://www.altlinux.org/Pipewire

$ systemctl --user disable --now pulseaudio{,.socket,-x11}
В выводе окажется следующее:

Created symlink /home/user/.config/systemd/user/pulseaudio.service > /dev/null.
Created symlink /home/user/.config/systemd/user/pulseaudio.socket > /dev/null.
Created symlink /home/user/.config/systemd/user/pulseaudio-x11.service > /dev/null.
Полностью заблокировать запуск pulseaudio:

$ systemctl --user mask pulseaudio{,.socket,-x11}

Откат на PulseAudio для текущего пользователя
Делаем действия в обратном порядке и инверсионно:

$ systemctl --user disable --now pipewire{,-pulse}{,.socket} wireplumber
$ systemctl --user unmask pulseaudio{,.socket,-x11}
$ systemctl --user enable --now pulseaudio{,.socket,-x11}
Проверка
$ pactl info | grep -i pulsea