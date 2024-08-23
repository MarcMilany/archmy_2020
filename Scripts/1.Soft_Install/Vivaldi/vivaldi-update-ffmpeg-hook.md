Это просто другой подход к поддержанию актуальности кодеков ffmpeg. В случае vivaldi-codecs-ffmpeg-extra-bin и vivaldi-snapshot-ffmpeg-codecsваши кодеки обновляются, когда сопровождающий пакета понимает, что они устарели, и отправляет обновление в AUR. В случае «этого» пакета и vivaldi-arm-bin(ARM-версия Vivaldi) отдельный скрипт или хук после установки/обновления pacmanвызывается каждый раз, когда Vivaldi устанавливается/обновляется. Хотя первый подход может показаться лучше, «этот» подход работает довольно хорошо из-за цикла обновления Vivaldi (в котором выходит около 2–4 новых релизов в месяц). Кроме того, «этот» подход более автоматизирован и означает, что вы полагаетесь только на частоту обновления одного пакета AUR, а не на два... колебания и обходные пути.
Когда я создавал этот пакет, после каждого обновления мне приходилось вручную запускать "/opt/vivaldi/update-ffmpeg", иначе видео не работали. Если воспроизведение видео работает после обновления даже без его запуска, то этот пакет больше не нужен.

vivaldi-update-ffmpeg.hook

[Trigger]
Operation = Install
Operation = Upgrade
Type = Package
Target = vivaldi

[Action]
Description = Enabling proprietary media playback in Vivaldi…
When = PostTransaction
Exec = /opt/vivaldi/update-ffmpeg


yay -S vivaldi-update-ffmpeg-hook --noconfirm  # Подключитесь для автоматического включения воспроизведения фирменных медиафайлов ; https://aur.archlinux.org/vivaldi-update-ffmpeg-hook.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/KucharczykL/vivaldi-update-ffmpeg-hook ; https://aur.archlinux.org/packages/vivaldi-update-ffmpeg-hook ; 
